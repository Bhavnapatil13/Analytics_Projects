from sqlalchemy import Column, Integer, Text, DateTime
from sqlalchemy.sql import func

from app.database import Base


class InterviewAnalysis(Base):
    __tablename__ = "interview_analyses"

    id = Column(Integer, primary_key=True, index=True)

    job_description = Column(Text, nullable=False)

    fit_assessment = Column(Text, nullable=False)

    matching_skills = Column(Text, nullable=False)

    skill_gaps = Column(Text, nullable=False)

    recommendations = Column(Text, nullable=False)

    interview_questions = Column(Text, nullable=False)

    created_at = Column(
        DateTime(timezone=True),
        server_default=func.now()
    )