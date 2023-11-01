# BookFinderApp

## 1. 프로젝트의 목적
- 구글 book search api 통해 책을 검색함
- 원하는 책을 검색함으로서 저자, 출판년도, 가격정보, 미리보기 지원함

## 2. 프로젝트 시작하는 방법
- 프로젝트 폴더에 BookFinderApp.xcodeproj 실행
- BookFinderApp.Spm swift package manager에 의해 필요한 라이브러리 다운로드 후 빌드 실행

## 3. 프로젝트 설명
- 스펙: ios 최소버전 15.0, 언어: Swift, 프로임워크 SwiftUI
- 코드 설명
    * ApiRouter: enum, 각 api에 따른 endpoint, method, header를 설정한다.
    * ApiService: struct, 실제 api 요청후 모델 매핑 및 에러 처리
    * AppSessionManager: class, URLSession 설정 타임 아웃 시간 및 로그 설정 
    * AppStateVM: obsableobject class, 앱의 모든 상태를 관리함

## 4. 라이브러리 설명
- SwiftyJSON 
    * 설명: 서버에서 받은 데이터를 JSON모델로 만들어 줌, 장점 Optional value 쉽게 벗길수 있음
    * 왜 사용했는가? api 통신후 받은 json nest deep 많아 모두 모델링하기 어려움, nest deep 모델을 벗겨 one deep로 모델링하기 위함
    
- Alamorefire 
    * 서버와 클라이언트간 통신을 싶게 해줌
    * 왜 사용했는가? 가장 많이쓰는 통신라이브러 안정성 추구
    * URLRequestConvertible, protocal을 통해 endpoint path, method, header 각 api 맞게 적용
    * EventMonitor protocal을 통해 통신 로그를 쉽게 볼수 있음
    
- SFSafeSymbols 
    * 애플에서 제공하는 이미지 아이콘 이미지를 쉽게 찾을수 있음
    * 아이콘을 폰트로 사용함으로서 다양한 디바이스 해상도 대응, 칼라 적용 쉬움

- SDWebImageSwiftUI
    * 이미지를 쉽게 다운로드 및 캐싱 가능
    
    
