# 책 리뷰 관리 앱 프로젝트

## 프로젝트 개요
- 이름: BookLog(책 리뷰 관리 앱)
- 목표: 책을 검색하고, 내 서재를 관리하며, 리뷰와 평점을 기록하는 앱
- 사용 기술: UIKit, Core Data, Google Books API, SDWebImage 등
- 개발 기간: 2025.02.13 ~ 2025.02.18
- 주요 기능:
    - Google Books API를 이용한 책 검색
    - Core Data를 활용한 데이터 저장 및 관리
    - 책 리뷰 및 평점 기록
    - UITableView를 활용한 UI 구성
    - 다크 모드 지원
    - os_log를 활용한 로그 관리

## 주요 기능 및 개발 과정
1. Google Books API를 활용한 책 검색
    - 구현 목표:
        - 사용자가 검색어를 입력하면 Google Books API에서 책 데이터를 받아와 리스트에 표시
    - 겪었던 문제 및 해결 방법:
        - API Key를 코드에 하드코딩하지 않고 `.xcconfig`로 관리
        - SDWebImage를 활용한 썸네일 이미지 로딩 최적화
2. Core Data를 활용한 데이터 저장 및 관리
    - 구현 목표:
        - 책을 검색해서 내 서재에 추가하고, Core Data에 저장
    - 겪었던 문제 및 해결 방법:
        - Core Data 모델 변경 시 마이그레이션 문제 발생 → Core Data 자동 마이그레이션 적용(`NSPersistentContainer` 설정)
        - 데이터가 많아질수록 앱이 느려지는 문제 발생 → `FetchedResultsController`를 사용해 효율적으로 데이터 표시
3. 책 리뷰 및 평점 기록 기능 구현
    - 구현 목표:
        - 사용자가 책을 추가할 때 리뷰 및 평점을 기록할 수 있도록 함
    - 겪었던 문제 및 해결 방법:
        - `UIImageView` + `UISlider`를 활용하여 사용자가 별점을 0.5 단위로 조정할 수 있도록 구현
4. 다크 모드 지원
    - 구현 목표:
        - 시스템 설정에 따른 다크 모드 지원
    - 겪었던 문제 및 해결 방법:
        - Navigation Bar 및 Tab Bar 다크 모드 미적용 → `overrideUserInterfaceStyle`설정
5. os_log를 활용한 로그 관리
    - 구현 목표:
        - 디버깅을 편하게 하고, 중요한 로그를 효율적으로 관리
    - 겪었던 문제 & 해결 방법:
        - `print()`를 남용하여 릴리즈 빌드에서도 로그가 노출될 위험 → `os_log`를 사용하여 효율적인 로그 관리
        - 민감한 정보 보호 → `%{private}s` 사용

## 프로젝트에서 배운 점 및 개선할 점

### 배운점
1. Core Data 모델링의 중요성과 자동 마이그레이션 설정
2. Google Books API와 연동하면서 네트워크 에러 처리 경험
3. os_log를 활용한 로그 관리의 필요성 및 로그 관리를 체계적으로 하는 법

### 개선할 점
1. Combine을 더 적극적으로 활용하여 비동기 코드 최적화
2. Unit Test를 추가하여 데이터 저장 기능 검증
