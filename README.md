# DangProject 
<img src = "https://user-images.githubusercontent.com/73861795/210137237-14bee6d1-e6d5-4112-9f31-24ae8f41a557.png" width="300" height="300"/>


>## 오늘 하루 당 몇 그램을 섭취하셨나요?
>#### 🗓 개발 기간: 2022.01.19 - 2022.10.16
<br/>
<br/>

## 💻 Project Introduction
![DangProjectPreviewShot](https://user-images.githubusercontent.com/73861795/210135012-0482cf53-ea64-42e5-bf2d-d1b2895cfae3.png)

<br/>
<br/>

## 🐝 Team Member Introduction


<br/>
<br/>

## 🍎 Tech Stack
<img src="https://img.shields.io/badge/Xcode 14.0-147EFB?style=flat&logo=Xcode&logoColor=white"/> <img src="https://img.shields.io/badge/Swift 5.0-F05138?style=flat&logo=Swift&logoColor=white"/> <img src="https://img.shields.io/badge/RxSwift 6.5.0-B7178C?style=flat&logo=ReactiveX&logoColor=white"/> <img src="https://img.shields.io/badge/Firebase 9.1.0-FFCA28?style=flat&logo=Firebase&logoColor=white"/> <img src="https://img.shields.io/badge/Tuist 3.5.0-9146FF?style=flat&logo=Tuist&logoColor=white"/> 

<br/>
<br/>

## 🌐 Main Features of the Project
>### 🍎 애플 계정을 통해 회원가입, 로그인 할 수 있습니다.

<img src = "https://user-images.githubusercontent.com/73861795/210150195-c7f4af00-978d-4fe2-91e1-0829528d0376.png" width="231" height="500"/>

<br/>

>### 🎯 목표 당을 설정하세요!

<img src = "https://user-images.githubusercontent.com/73861795/210150308-5599b76b-f41d-4a44-9b35-1b5cf517e57d.png" width="231" height="500"/>

<br/>


>### 🍯 내가 먹은 음식의 당이 얼마나 들어가 있는지 검색 후 확인해보세요.

<img src = "https://user-images.githubusercontent.com/73861795/210150340-57b976ea-945c-4913-861c-711449ea4761.png" width="231" height="500"/> <img src = "https://user-images.githubusercontent.com/73861795/210150346-0a165a51-1742-49e5-b7a7-7d21d83ed6b7.png" width="231" height="500"/>

<br/>


>### 🍯 내가 먹은 음식을 추가하면 오늘 먹은 Section에서 확인가능합니다.

<img src = "https://user-images.githubusercontent.com/73861795/210150348-f1f8ae44-4e07-4259-bd82-9a14b3b30254.png" width="231" height="500"/> <img src = "https://user-images.githubusercontent.com/73861795/210150352-5312bd2e-85da-4cbc-84d6-755316e148ec.png" width="231" height="500"/> <img src = "https://user-images.githubusercontent.com/73861795/210150368-368fa66a-7f53-4fd2-8afa-2333da1de2cc.png" width="231" height="500"/>

<br/>


>### 📅 Calendar로 이전 먹은 기록들 확인가능합니다.

<img src = "https://user-images.githubusercontent.com/73861795/210150358-0301f985-96ff-49a3-874d-4474b51f734b.png" width="231" height="500"/>

<br/>



 
>### ⏰ 잊지 말고 알림 설정까지!

<img src = "https://user-images.githubusercontent.com/73861795/210150371-e01fd1ab-9d9f-4e61-8b47-233bfdd72712.png" width="231" height="500"/> <img src = "https://user-images.githubusercontent.com/73861795/210150372-4e25e5be-da6d-45eb-a3c5-936a2150749c.png" width="231" height="500"/>

<br/>
<br/>


## ⚒️ Architecture

<img src = "https://user-images.githubusercontent.com/73861795/210162595-53cf53cf-5f1f-4890-b4ea-740d053b39c1.png" width="817" height="458"/>

>### MVVM

- MVVM은 뷰컨트롤러는 뷰를 그리는 것에만 집중하고, 그 외의 Object 관리나, UI 로직 처리는 뷰 모델에서 진행하도록 했습니다.

<br/>

<img src = "https://user-images.githubusercontent.com/73861795/210164511-7b747ae0-de84-4f3f-b752-82d9b875182f.png" width="817" height="458"/>

>### 헥사고날 아키텍처(클린 아키텍처)

- 헥사고날 아키텍처는 클린 아키텍처를 좀 더 일반적인 용어로 설명한 것입니다.
- UI로직은 viewModel, 비즈니스 로직은 UseCase로, 네트워크나 외부 프레임워크 요청은 repository로 하여 각각 계층 별로 presentation Layer, domain Layer, Data layer 로 분리하였습니다.
- 핵사고날 아키텍처의 구조는 비즈니스 로직을 다른 로직으로부터 보호하기위해 각 입출력 포트와 어댑터로 안쪽에 있는 유스케이스(비즈니스로직)가 속한 계층만 아예 분리하여 지키는 구조 입니다.

<br/>

>### Coordinator

- View가 어디에서 사용하더라도 화면 전환을 유연하게 할 수 있게 코디네이터 패턴을 사용하였습니다.
- Parent Coordinator와 Child Coordinator 가지기 때문에 딜리게이트로 상위 코디네이터에 접근이 용이합니다.
- 관리하기 쉽게 Coordinator와 ViewController 1:1 관계를 갖습니다.
- View사이에 Object 데이터 전달도 담당합니다.

<br/>


>### DIContainer

- DIContainer로 의존성 객체 주입을 따로 가지게 했습니다.
- Coordinator 안에 객체로 있으며(1:1) 모든 Layer의 의존성을 주입시키고 해당 viewController를 뱉어주는 팩토리로서 사용했습니다.


<br/>
<br/>

## 👨🏻‍💻 Technical Challenge

>### DeskCache 작업

- 서버로 부터 받은 데이터들은 CoreData에 저장하고 불러오게 끔 캐시 작업 하였습니다. 



<br/>


>### Firebase를 활용한 데이터 스트리밍

- firestore를 이용하여  저장하였습니다.
- 뿐만아니라 Authentication, storage를 이용하여 회원정보 관리도 구현하였습니다.

<br/>


>### RxSwift 

- 데이터가 발생하는 시점에서부터 뷰에 그려지기까지 하나의 큰 스트림으로 데이터를 바인딩해주었습니다.

>### Tuist

- Tuist를 사용하여 프로젝트 및 라이브러리들 관리해주었습니다.

<br/>
<br/>

![Top Langs](https://github-readme-stats.vercel.app/api/top-langs/?username=ornwoo96)
