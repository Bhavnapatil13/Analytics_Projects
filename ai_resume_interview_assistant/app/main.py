import json
from pathlib import Path

from fastapi import FastAPI, File, Form, UploadFile, HTTPException
from pypdf import PdfReader

from app.graph import interview_graph
from app.rag import build_vector_store, retrieve_context
from app.database import engine, Base, SessionLocal
from app import models


app = FastAPI(
    title="AI Resume & Interview Assistant",
    version="1.0.0",
    description="RAG + LangGraph + FastAPI project for AI/ML interview preparation.",
)
Base.metadata.create_all(bind=engine)

DATA_DIR = Path("data")
DATA_DIR.mkdir(exist_ok=True)


@app.get("/")
def home():
    return {
        "message": "AI Resume & Interview Assistant API is running.",
        "docs": "/docs",
    }


@app.post("/resume/upload")
async def upload_resume(file: UploadFile = File(...)):
    if not file.filename.lower().endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Please upload a PDF resume.")

    content = await file.read()
    file_path = DATA_DIR / file.filename
    file_path.write_bytes(content)

    reader = PdfReader(str(file_path))
    text = "\n".join(page.extract_text() or "" for page in reader.pages).strip()

    if not text:
        raise HTTPException(
            status_code=400,
            detail="Could not extract text from the PDF."
        )

    build_vector_store(text)

    return {
    "message": "Resume processed successfully.",
    "filename": file.filename,
    "pages": len(reader.pages),
    "characters_extracted": len(text),
}


@app.post("/analyze")
def analyze_resume(
    job_description: str = Form(...),
    task: str = Form(
        "Analyze the candidate's fit for this role, identify skill gaps, "
        "and generate 5 technical interview questions."
    ),
):
    try:
        result = interview_graph.invoke(
            {
                "job_description": job_description,
                "task": task,
            }
        )

        # Get structured Pydantic report
        report = result["final_answer"]

        # Convert Pydantic model to normal dictionary
        if hasattr(report, "model_dump"):
            report = report.model_dump()

        # Save analysis to SQLite
        db = SessionLocal()

        try:
            analysis = models.InterviewAnalysis(
                job_description=job_description,
                fit_assessment=report["fit_assessment"],
                matching_skills=json.dumps(report["matching_skills"]),
                skill_gaps=json.dumps(report["skill_gaps"]),
                recommendations=json.dumps(report["recommendations"]),
                interview_questions=json.dumps(
                    report["interview_questions"]
                ),
            )

            db.add(analysis)
            db.commit()
            db.refresh(analysis)

        finally:
            db.close()

    except Exception as exc:
        raise HTTPException(
            status_code=500,
            detail=f"Analysis failed: {exc}",
        )

    return {
        "status": "success",
        "report": report,
    }
    
@app.get("/history")
def get_history():
    db = SessionLocal()

    try:
        analyses = (
            db.query(models.InterviewAnalysis)
            .order_by(models.InterviewAnalysis.created_at.desc())
            .all()
        )

        return {
            "status": "success",
            "count": len(analyses),
            "history": [
                {
                    "id": analysis.id,
                    "job_description": analysis.job_description,
                    "fit_assessment": analysis.fit_assessment,
                    "matching_skills": json.loads(analysis.matching_skills),
                    "skill_gaps": json.loads(analysis.skill_gaps),
                    "recommendations": json.loads(analysis.recommendations),
                    "interview_questions": json.loads(analysis.interview_questions),
                    "created_at": analysis.created_at,
                }
                for analysis in analyses
            ],
        }

    finally:
        db.close()    
    
    
@app.get("/test-retrieval")
def test_retrieval(query: str):
    context = retrieve_context(query)

    return {
        "query": query,
        "retrieved_context": context
    }
