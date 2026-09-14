import requests
import streamlit as st
import json


    # ---------------------------------------------------------
    # Configuration
    # ---------------------------------------------------------

API_URL = "http://127.0.0.1:8000"


st.set_page_config(
        page_title="AI Resume & Interview Assistant",
        page_icon="🤖",
        layout="wide",
        initial_sidebar_state="expanded",
    )

if "resume_uploaded" not in st.session_state:
        st.session_state["resume_uploaded"] = False

if "analysis" not in st.session_state:
        st.session_state["analysis"] = None
report = st.session_state.get("analysis") or {}

    # --------------------------------------------------
    # Custom Styling
    # --------------------------------------------------

st.markdown(
        """
        <style>
            .main {
                padding-top: 1rem;
            }

            .block-container {
                max-width: 1200px;
                padding-top: 2rem;
                padding-bottom: 3rem;
            }

            h1 {
                font-size: 2.6rem !important;
                font-weight: 700 !important;
            }

            h2 {
                margin-top: 1.5rem !important;
            }

            h3 {
                margin-top: 1rem !important;
            }

            .success-box {
                padding: 1rem;
                border-radius: 10px;
                border: 1px solid rgba(0, 200, 100, 0.3);
                background-color: rgba(0, 200, 100, 0.08);
            }

            .info-box {
                padding: 1rem;
                border-radius: 10px;
                border: 1px solid rgba(80, 140, 255, 0.3);
                background-color: rgba(80, 140, 255, 0.08);
            }
        </style>
        """,
        unsafe_allow_html=True,
    )

    # ---------------------------------------------------------
    # Header
    # ---------------------------------------------------------

st.title("🤖 AI Resume & Interview Assistant")

st.markdown(
        """
        **AI-powered resume analysis and interview preparation**

        Upload your resume and provide a job description to get:
        **skill matching, skill-gap analysis, personalized recommendations,
        and technical interview questions.**
        """
    )

st.divider()

    # --------------------------------------------------
    # Sidebar
    # --------------------------------------------------

with st.sidebar:
        st.header("⚙️ Application")

        st.markdown(
            """
            ### How it works

            1. 📄 Upload your resume
            2. 💼 Enter the job description
            3. 🔍 Analyze your fit
            4. 🎯 Review skill gaps
            5. ❓ Prepare interview questions
            """
        )

        st.divider()

        st.caption("Powered by")
        st.caption("RAG • ChromaDB • LangChain • LangGraph • Groq • FastAPI")


    # ---------------------------------------------------------
    # Resume Upload
    # ---------------------------------------------------------

st.subheader("📄 Step 1: Upload Your Resume")

uploaded_file = st.file_uploader(
        "Upload your resume in PDF format",
        type=["pdf"],
    )


if uploaded_file is not None:

        if st.button("📤 Upload & Process Resume"):

            with st.spinner("Processing your resume..."):

                try:
                    response = requests.post(
                        f"{API_URL}/resume/upload",
                        files={
                            "file": (
                                uploaded_file.name,
                                uploaded_file.getvalue(),
                                "application/pdf",
                            )
                        },
                        timeout=120,
                    )

                    if response.status_code == 200:
                        data = response.json()

                        st.session_state["resume_uploaded"] = True

                        st.success("✅ Resume processed successfully!")

                        st.info(
                            f"Pages: {data['pages']} | "
                            f"Characters extracted: {data['characters_extracted']}"
                        )

                    else:
                        st.error(
                            f"Resume processing failed: {response.text}"
                        )

                except requests.exceptions.RequestException as exc:
                    st.error(
                        f"Could not connect to FastAPI: {exc}"
                    )


st.divider()


    # ---------------------------------------------------------
    # Job Description
    # ---------------------------------------------------------

st.subheader("💼 Step 2: Enter Job Description")

job_description = st.text_area(
        "Paste the job description here",
        height=250,
        placeholder=(
            "Example:\n\n"
            "We are looking for an AI/ML Intern with strong Python "
            "and OOP knowledge. Experience with LLMs, RAG, embeddings, "
            "LangChain, LangGraph, FastAPI, SQL and NoSQL is preferred..."
        ),
    )


    # ---------------------------------------------------------
    # Analysis
    # ---------------------------------------------------------

st.subheader("🔍 Step 3: Analyze Your Fit")

task = st.text_area(
        "Analysis instructions",
        value=(
            "Analyze the candidate's fit for this role, identify skill gaps, "
            "provide practical recommendations, and generate exactly 5 "
            "technical interview questions with concise model answers."
        ),
        height=100,
    )


if st.button("🚀 Analyze Resume", type="primary"):

        if not st.session_state.get("resume_uploaded", False):
            st.warning(
                "⚠️ Please upload and process your resume first."
            )

        elif not job_description.strip():
            st.warning(
                "⚠️ Please enter a job description."
            )

        else:

            with st.spinner(
                "Analyzing your resume with RAG + LangGraph + AI..."
            ):
                try:
                    response = requests.post(
                        f"{API_URL}/analyze",
                        data={
                            "job_description": job_description,
                            "task": task,
                        },
                        timeout=180,
                    )

                    if response.status_code == 200:
                        data = response.json()

                        st.session_state["analysis"] = data.get("report")

                        if st.session_state["analysis"] is None:
                            st.error("Backend returned no analysis report.")
                            st.stop()

                        st.success("✅ Analysis completed successfully!")

                    else:
                        st.error(
                            f"Analysis failed: {response.text}"
                        )

                except requests.exceptions.RequestException as exc:
                    st.error(
                        f"Could not connect to FastAPI: {exc}"
                    )


    # ---------------------------------------------------------
    # Display Analysis
    # ---------------------------------------------------------

if "analysis" in st.session_state and st.session_state["analysis"] is not None:

        report = st.session_state["analysis"]

        st.divider()

        st.header("📊 Interview Preparation Report")


        # Fit Assessment
        st.subheader("🎯 Fit Assessment")

        st.write(
            report["fit_assessment"]
        )


    # --------------------------------------------------
    # Matching Skills
    # --------------------------------------------------

        st.subheader("✅ Matching Skills")

        matching_skills = report.get("matching_skills", [])

        if matching_skills:
         cols = st.columns(2)

        for index, skill in enumerate(matching_skills):
            with cols[index % 2]:
                st.markdown(
                    f"""
                    <div class="success-box">
                        <strong>✓ {skill}</strong>
                    </div>
                    """,
                    unsafe_allow_html=True,
                )
        else:
            st.info("No matching skills were identified.")


    # --------------------------------------------------
    # Skill Gaps
    # --------------------------------------------------

        st.subheader("⚠️ Skill Gaps")

        skill_gaps = report.get("skill_gaps", [])

        if skill_gaps:
            for gap in skill_gaps:
             st.warning(gap)
        else:
            st.success("No major skill gaps identified.")


    # --------------------------------------------------
    # Recommendations
    # --------------------------------------------------

        st.subheader("💡 Recommendations")

        recommendations = report.get("recommendations", [])

        if recommendations:
            for index, recommendation in enumerate(recommendations, start=1):
                st.markdown(
                f"""
                <div class="info-box">
                    <strong>{index}. {recommendation}</strong>
                </div>
                """,
                unsafe_allow_html=True,
            )
        else:
            st.info("No recommendations available.")


    # --------------------------------------------------
    # Interview Questions
    # --------------------------------------------------

st.subheader("❓ Technical Interview Questions")

report = st.session_state.get("analysis") or {}
interview_questions = report.get("interview_questions", [])

if interview_questions:

    for index, item in enumerate(interview_questions, start=1):

        with st.expander(f"Question {index}", expanded=False):

            if isinstance(item, dict):
                question_text = item.get("question", "")
                model_answer = item.get("model_answer", "")
            else:
                question_text = str(item)
                model_answer = ""

            st.markdown(f"**{question_text}**")

            if model_answer:
                st.markdown("### 💡 Model Answer")
                st.info(model_answer)
            else:
                st.warning("Model answer was not generated for this question.")

else:
    st.info("No interview questions were generated.")

    # --------------------------------------------
    # Analysis History
    # --------------------------------------------

st.divider()

st.header("📚 Analysis History")

try:
            history_response = requests.get(
                "http://127.0.0.1:8000/history",
                timeout=10
            )

            if history_response.status_code == 200:
                history_data = history_response.json()
                history = history_data.get("history", [])

                if history:
                    st.success(f"Found {len(history)} previous analyses.")

                    for item in history:
                        created_at = item.get("created_at", "Unknown date")
                        job_description = item.get("job_description", "")

                        with st.expander(
                            f"📄 Analysis #{item.get('id', 'N/A')} — {created_at}"
                        ):
                            st.markdown("### 💼 Job Description")
                            st.write(job_description)

                            st.markdown("### 🎯 Fit Assessment")
                            st.write(item.get("fit_assessment", "Not available"))

                            st.markdown("### ✅ Matching Skills")

                            matching_skills = item.get("matching_skills", "[]")

                            try:
                                matching_skills = json.loads(matching_skills)
                            except:
                                matching_skills = []

                            if matching_skills:
                                for skill in matching_skills:
                                    st.markdown(f"- {skill}")
                            else:
                                st.info("No matching skills recorded.")

                            st.markdown("### ⚠️ Skill Gaps")

                            skill_gaps = item.get("skill_gaps", "[]")

                            try:
                                skill_gaps = json.loads(skill_gaps)
                            except:
                                skill_gaps = []

                            if skill_gaps:
                                for gap in skill_gaps:
                                    st.markdown(f"- {gap}")
                            else:
                                st.info("No skill gaps recorded.")

                else:
                    st.info("No previous analyses found.")

            else:
                st.warning("Could not load analysis history.")

except requests.exceptions.RequestException as exc:
            st.warning(
                f"Could not connect to FastAPI history endpoint: {exc}"
            )

    # --------------------------------------------------
    # Footer
    # --------------------------------------------------

st.divider()

st.caption(
        "Built with Python • FastAPI • LangGraph • LangChain • "
        "ChromaDB • HuggingFace Embeddings • Groq • SQLite"
)