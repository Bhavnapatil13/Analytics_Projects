from typing import TypedDict, List
from pydantic import BaseModel, Field

from langchain_groq import ChatGroq
from langchain_core.prompts import ChatPromptTemplate
from langgraph.graph import StateGraph, START, END

from app.config import settings
from app.rag import retrieve_context

class InterviewQuestion(BaseModel):
    question: str = Field(
        description="A technical interview question relevant to the job."
    )

    model_answer: str = Field(
        description="A concise 2-3 sentence model answer to the question."
    )
    
class InterviewReport(BaseModel):
    fit_assessment: str = Field(
        description="Overall assessment of how well the candidate fits the job."
    )

    matching_skills: List[str] = Field(
        description="Skills from the resume that match the job description."
    )

    skill_gaps: List[str] = Field(
        description="Skills required by the job that are missing or weak in the resume."
    )

    recommendations: List[str] = Field(
        description="Practical preparation recommendations for the candidate."
    )

    interview_questions: List[InterviewQuestion] = Field(
        description="Exactly five technical interview questions, each with a concise model answer."
    )


# ---------------------------------------------------------
# 1. LangGraph State
# ---------------------------------------------------------

class InterviewState(TypedDict, total=False):
    resume_context: str
    job_description: str
    task: str

    skill_analysis: str
    skill_gaps: str
    interview_questions: List[InterviewQuestion]

    final_answer: InterviewReport


# ---------------------------------------------------------
# 2. LLM
# ---------------------------------------------------------

llm = ChatGroq(
    api_key=settings.groq_api_key,
    model=settings.groq_model,
    temperature=0.2,
)


# ---------------------------------------------------------
# 3. RAG Retrieval Node
# ---------------------------------------------------------

def retrieve_node(state: InterviewState):
    query = f"""
Analyze this job description and retrieve the most relevant
information from the candidate's resume.

Job Description:
{state["job_description"]}
"""

    context = retrieve_context(query)

    return {
        "resume_context": context
    }


# ---------------------------------------------------------
# 4. Skill Analysis Node
# ---------------------------------------------------------

def skill_analysis_node(state: InterviewState):

    prompt = ChatPromptTemplate.from_template(
        """
You are an AI/ML recruitment assistant.

Compare the job description with the candidate's resume.

Identify:
1. Required skills from the job description
2. Skills demonstrated in the resume
3. Relevant projects or experience

IMPORTANT:
Use ONLY the provided resume context when claiming that
the candidate has a particular skill or experience.

JOB DESCRIPTION:
{job_description}

RESUME CONTEXT:
{resume_context}

Return a concise skill analysis.
"""
    )

    chain = prompt | llm

    response = chain.invoke(
        {
            "job_description": state["job_description"],
            "resume_context": state["resume_context"],
        }
    )

    return {
        "skill_analysis": response.content
    }


# ---------------------------------------------------------
# 5. Skill Gap Analysis Node
# ---------------------------------------------------------

def skill_gap_node(state: InterviewState):

    prompt = ChatPromptTemplate.from_template(
        """
You are an AI/ML career advisor.

Based on the job description and the previous skill analysis,
identify the candidate's skill gaps.

Classify skills into:

- Strong Match
- Partial Match
- Gap / Needs Preparation

Do not invent skills that are not present in the resume.

JOB DESCRIPTION:
{job_description}

SKILL ANALYSIS:
{skill_analysis}

Provide practical recommendations for what the candidate
should prepare for the interview.
"""
    )

    chain = prompt | llm

    response = chain.invoke(
        {
            "job_description": state["job_description"],
            "skill_analysis": state["skill_analysis"],
        }
    )

    return {
        "skill_gaps": response.content
    }


# ---------------------------------------------------------
# 6. Interview Question Generation Node
# ---------------------------------------------------------

def interview_questions_node(state: InterviewState):

    prompt = ChatPromptTemplate.from_template(
        """
You are an AI/ML technical interviewer.

Generate exactly 5 technical interview questions for the candidate.

Questions should be based on:
1. The job description
2. The candidate's demonstrated skills
3. The identified skill gaps

Include a mixture of:

- Python / OOP
- Machine Learning
- LLM / GenAI
- RAG / Embeddings
- LangChain / LangGraph
- FastAPI / REST APIs
- SQL where relevant

For EACH question, generate:
- One clear technical interview question
- One concise model answer

The model answer must be 2-3 sentences maximum.

Do not generate questions without answers.
Do not generate answers without questions.
Generate exactly 5 question-answer pairs.

IMPORTANT:
Follow this EXACT format for every question:

Question 1: <question>
Model Answer: <2-3 sentence answer>

Question 2: <question>
Model Answer: <2-3 sentence answer>

Question 3: <question>
Model Answer: <2-3 sentence answer>

Question 4: <question>
Model Answer: <2-3 sentence answer>

Question 5: <question>
Model Answer: <2-3 sentence answer>

Do NOT output questions alone.
Every question MUST have a Model Answer.

JOB DESCRIPTION:
{job_description}

SKILL ANALYSIS:
{skill_analysis}

SKILL GAPS:
{skill_gaps}
"""
    )

    chain = prompt | llm

    response = chain.invoke(
        {
            "job_description": state["job_description"],
            "skill_analysis": state["skill_analysis"],
            "skill_gaps": state["skill_gaps"],
        }
    )

    return {
        "interview_questions": response.content
    }


# ---------------------------------------------------------
# 7. Final Report Node
# ---------------------------------------------------------

def final_report_node(state: InterviewState):

    structured_llm = llm.with_structured_output(InterviewReport)

    prompt = ChatPromptTemplate.from_template(
        """
You are an AI/ML interview preparation assistant.

Create a structured interview preparation report using the
analysis generated by the previous workflow nodes.

Return:
- Overall candidate fit
- Matching skills
- Skill gaps
- Practical recommendations
- Exactly 5 interview questions

Keep every item concise.

JOB DESCRIPTION:
{job_description}

SKILL ANALYSIS:
{skill_analysis}

SKILL GAPS:
{skill_gaps}

INTERVIEW QUESTIONS:
{interview_questions}
"""
    )

    chain = prompt | structured_llm

    response = chain.invoke(
        {
            "job_description": state["job_description"],
            "skill_analysis": state["skill_analysis"],
            "skill_gaps": state["skill_gaps"],
            "interview_questions": state["interview_questions"],
        }
    )

    return {
        "final_answer": response
    }


# ---------------------------------------------------------
# 8. Build LangGraph
# ---------------------------------------------------------

def build_graph():

    graph = StateGraph(InterviewState)

    # Add nodes
    graph.add_node("retrieve", retrieve_node)
    graph.add_node("skill_analysis", skill_analysis_node)
    graph.add_node("skill_gap", skill_gap_node)
    graph.add_node("interview_questions", interview_questions_node)
    graph.add_node("final_report", final_report_node)

    # Define workflow
    graph.add_edge(START, "retrieve")

    graph.add_edge(
        "retrieve",
        "skill_analysis"
    )

    graph.add_edge(
        "skill_analysis",
        "skill_gap"
    )

    graph.add_edge(
        "skill_gap",
        "interview_questions"
    )

    graph.add_edge(
        "interview_questions",
        "final_report"
    )

    graph.add_edge(
        "final_report",
        END
    )

    return graph.compile()


# Create compiled graph
interview_graph = build_graph()