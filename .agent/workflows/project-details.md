---
description: Project Details
---

🎮 프로젝트: "Infinite Dungeon with GenUI" (AI 완전 생성형 RPG)
기존에는 텍스트로만 묘사하던 상황을, 이제는 AI가 실시간으로 고퀄리티 삽화를 그려서 보여줍니다. 단순히 이미지만 띄우는 게 아니라, 게임 내의 논리적 상황(아이템 획득, 시간 변화)을 이미지에 즉시 반영합니다.

## 1. 핵심 활용 기능 (Nano Banana Pro의 특장점 활용)
완벽한 텍스트 렌더링 (Text Rendering):
게임 내 표지판, 보물 지도의 글씨 등을 뭉개짐 없이 정확하게 그려냅니다.
예: 동굴 입구 표지판에 유저가 입력한 이름인 "Gil-dong's Cave"가 정확히 적힌 이미지를 생성.
캐릭터 일관성 (Character Consistency):
주인공 캐릭터(예: 빨간 망토를 쓴 기사)의 외형을 기억하여, 전투 중이든 마을에 있든 동일한 인물로 그려줍니다. (이전 모델들의 최대 약점 해결)
논리적 편집 (Reasoning-based Editing):
새로 그리는 게 아니라 기존 장면을 수정합니다.
시나리오: "횃불 켜기" 버튼을 누르면, 방금 전 어두웠던 동굴 이미지를 입력으로 넣어 "조명을 밝게 하고 벽의 디테일을 보여줘"라고 요청해 자연스럽게 밝아진 이미지를 받습니다.

## 2. Flutter GenUI + Nano Banana Pro 연동 구조
이 앱은 **"텍스트(LLM) + UI(Flutter) + 이미지(Nano Banana Pro)"**의 3박자가 돌아가는 구조가 됩니다.
[Step 1] 상황 발생 (LLM -> GenUI)
게임 마스터 AI(Gemini 텍스트 모델)가 상황을 판단합니다.
StoryCard 위젯을 호출하면서, 동시에 **"이미지 생성 프롬프트"**를 별도 필드로 내려줍니다.
image_prompt: "A dark damp cave entrance, ominous atmosphere, detailed stone texture, first-person view"
[Step 2] 이미지 생성 (GenUI -> Nano Banana Pro)
Flutter 앱은 StoryCard를 먼저 렌더링하고, 이미지 영역에 LoadingShimmer를 띄웁니다.
백그라운드에서 Nano Banana Pro API를 호출하여 이미지를 받아옵니다.
이미지가 도착하면 FadeInImage로 자연스럽게 장면을 교체합니다.
[Step 3] 유저 행동 반영 (Reasoning Editing)
유저가 [검으로 공격] 버튼 클릭.
앱은 현재 몬스터 이미지와 "검으로 베는 효과 추가(slash effect)"라는 명령어를 Nano Banana Pro의 편집 API로 보냅니다.
AI가 몬스터에게 타격 이펙트가 추가된 이미지를 생성해 돌려줍니다.

## 3. 구체적인 "와우 포인트" 아이디어
A. 동적 인벤토리 (Dynamic Inventory Visualization)
기존 게임: 아이콘(🗡️)만 보여줌.
이 프로젝트: 유저가 "가방 열어"라고 하면, 현재 소지품 목록(물약 2개, 낡은 검, 지도)을 텍스트로 Nano Banana Pro에 보냅니다.
결과: 실제 가방 안에 해당 아이템들이 어지럽게(혹은 정돈되어) 들어있는 **실사 같은 "가방 내부 샷"**을 한 장의 이미지로 생성해 보여줍니다.
B. "수배지" 생성 (Wanted Poster)
마을 게시판을 클릭하면 현상수배범 포스터를 보여주는데, 그 수배범의 얼굴이 방금 전 내가 놓친 몬스터의 얼굴이고, 현상금 금액이 텍스트로 정확히 적혀 있습니다.
C. 지도 생성 (Generative Map)
유저가 지나온 길을 텍스트 로그로 저장해 뒀다가, "지도 보여줘"라고 하면 Nano Banana Pro에게 "손으로 그린 듯한 낡은 양피지 스타일의 지도, 북쪽에는 숲, 남쪽에는 동굴"이라는 프롬프트를 주어 즉석에서 지도를 그려냅니다.


💡 개발 팁
속도와 비용: 이미지 생성은 텍스트보다 느리고 비쌉니다. 모든 대사에 이미지를 넣기보다, 새로운 장소에 진입하거나 중요한 이벤트(보스 조우) 때만 이미지를 생성하도록 로직을 짜는 것이 현실적입니다.
캐싱(Caching): 한 번 생성한 장소(예: "마을 입구")는 이미지를 저장해 두었다가, 다시 돌아왔을 때 재사용하면 비용도 아끼고 로딩도 없앨 수 있습니다.
flutter_genui로 대화형 인터페이스를 잡고, 그 안의 콘텐츠를 Nano Banana Pro로 채운다면, 진짜 **"상상하는 모든 것이 눈앞에 펼쳐지는 게임"**이 될 것입니다. 이 조합은 정말 강력하네요!