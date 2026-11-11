from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime

app = FastAPI(
    title="WORKMATE AI",
    description="Hybrid AI Backend Demo",
    version="0.1.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

class WorkRequest(BaseModel):
    content: str

class WorkResponse(BaseModel):
    title: str
    summary: str
    original_content: str
    created_at: str
    status: str

@app.get("/")
def home():
    return {
        "app": "WORKMATE AI",
        "version": "0.1.0",
        "status": "running"
    }

@app.get("/health")
def health():
    return {
        "status": "healthy",
        "server": "WORKMATE AI Backend"
    }

@app.post("/api/summarize", response_model=WorkResponse)
def summarize_work(request: WorkRequest):

    content = request.content.strip()

    if not content:
        return WorkResponse(
            title="내용 없음",
            summary="업무 내용을 입력해 주세요.",
            original_content="",
            created_at=datetime.now().isoformat(),
            status="empty"
        )

    # Demo용 임시 요약 로직
    # 추후 실제 AI 모델로 교체 예정
    title = content[:25]

    summary = (
        f"업무 내용: {content}\n"
        "다음 단계: 담당자 확인 및 후속 일정 등록"
    )

    return WorkResponse(
        title=title,
        summary=summary,
        original_content=content,
        created_at=datetime.now().isoformat(),
        status="demo"
    )

