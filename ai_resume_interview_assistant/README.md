# AI Resume & Interview Assistant

An AI-powered resume analysis and interview preparation application that compares a candidate's resume with a job description using Retrieval-Augmented Generation (RAG), embeddings, vector search, LangChain, LangGraph, and an LLM.

The application extracts information from a resume PDF, retrieves relevant candidate information, analyzes job-fit and skill gaps, generates technical interview questions with model answers, and stores analysis history using SQLite.

---

## 🚀 Features

- 📄 Resume PDF upload and text extraction
- 🔎 Semantic resume search using embeddings
- 🧠 Retrieval-Augmented Generation (RAG)
- 🗃️ ChromaDB vector database
- 🔗 LangChain-based LLM workflow
- 🔄 LangGraph multi-step AI workflow
- 🤖 Groq LLM integration
- 🎯 Resume-to-job fit assessment
- ✅ Matching skill identification
- ⚠️ Skill-gap analysis
- 💡 Interview preparation recommendations
- ❓ Technical interview question generation
- 💬 Model answers for interview questions
- ⚡ FastAPI REST backend
- 🖥️ Streamlit web interface
- 🗄️ SQLite analysis history
- 📦 Pydantic structured output validation

---

## 🏗️ Architecture

```text
                    Resume PDF
                        |
                        v
                PDF Text Extraction
                        |
                        v
                 Text Chunking
                        |
                        v
              HuggingFace Embeddings
                        |
                        v
                    ChromaDB
                  Vector Store
                        |
                        |
Job Description --------+
                        |
                        v
                  LangGraph
                  Workflow
                        |
          +-------------+-------------+
          |             |             |
          v             v             v
     Skill Analysis  Skill Gaps   Interview Questions
          |             |             |
          +-------------+-------------+
                        |
                        v
                  Final Report
                        |
                        v
                    Groq LLM
                        |
             +----------+----------+
             |                     |
             v                     v
          FastAPI              Streamlit
             |                     |
             +----------+----------+
                        |
                        v
                   SQLite History