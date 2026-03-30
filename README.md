# FeedMe — 智能订阅 App

> 通过对话创建订阅，自动抓取内容，生成可直接消费的卡片。

---

## 产品核心流程

```
用户说话 → AI 理解意图 → 创建订阅 → 抓取内容 → 生成卡片 → 一键跳转
```

---

## 项目结构

```
FeedMe/
├── FeedMe.xcodeproj/          # Xcode 项目文件
└── FeedMe/
    ├── FeedMeApp.swift         # App 入口
    ├── Models.swift            # 数据模型 + Mock 数据
    ├── Theme.swift             # 颜色、字体、间距、通用组件
    ├── AppStore.swift          # 全局状态管理（ObservableObject）
    ├── MainTabView.swift       # Tab 导航（首页 / 发现）
    ├── HomeView.swift          # 首页 Feed（订阅卡片聚合）
    ├── ChatView.swift          # 对话页（创建订阅的 AI 对话）
    ├── AppCardView.swift       # App 类型卡片组件
    ├── EventCardView.swift     # 活动类型卡片组件
    └── SubscriptionsView.swift # 订阅管理页
```

---

## 如何运行

### 方式一：直接用 Xcode 打开（推荐）

```bash
open FeedMe.xcodeproj
```

- 选择模拟器（iPhone 15 Pro 推荐）
- `Cmd + R` 运行

> **要求：** Xcode 15+，iOS 17+ 模拟器

### 方式二：从文件新建（如 project.pbxproj 有问题）

1. Xcode → File → New → Project
2. 选 iOS → App
3. 名称填 `FeedMe`，Language = Swift，Interface = SwiftUI
4. 把 `FeedMe/` 目录下所有 `.swift` 文件拖进去（替换自动生成的 ContentView.swift）

---

## 页面说明

### 🏠 首页（HomeView）
- 顶部：订阅筛选 Chips，点击过滤对应订阅内容
- 卡片流：App 卡片 + 活动卡片混合展示
- 下拉刷新支持

### 💬 发现页（ChatView）
- 欢迎引导 + 6 个快捷 Suggestion
- 用户发消息 → AI 分析意图 → 返回订阅确认卡片
- 点"添加到首页"→ 自动跳回首页并出现在 Feed 里

### 📋 订阅管理（SubscriptionsView）
- 右上角 icon 进入
- 显示订阅统计（总数、应用数、活动数、发现内容数）
- 可删除订阅（同时移除对应 Feed 内容）

---

## 卡片类型

### App 卡片
| 元素 | 说明 |
|------|------|
| App 图标 | 根据 App 名生成渐变色占位（真实版用 AsyncImage） |
| 名称 + 开发者 | |
| 星级评分 | 支持半星 |
| "获取"按钮 | 点击直跳 App Store |
| 描述 + 标签 | 来自小红书笔记提炼 |

### 活动卡片
| 元素 | 说明 |
|------|------|
| 封面图 | 渐变色占位（真实版用 AsyncImage） |
| 时间地点 | 结构化展示 |
| "立即报名"按钮 | 渐变色 CTA，点击跳转报名页 |
| 价格 | 免费活动高亮绿色显示 |

---

## 下一步：接入真实后端

### 后端技术栈（建议）

```
FastAPI (Python)
├── /api/chat          POST  → 意图识别（接 Claude/OpenAI API）
├── /api/subscriptions GET/POST/DELETE → 订阅 CRUD
└── /api/feed          GET   → 获取订阅内容

内容抓取：
├── 小红书：通过搜索接口抓取相关笔记
├── App Store：Apple Search API（免费）
└── 活动平台：大众点评、活动行、Meetup
```

### Swift 端改造点

1. `AppStore.swift` → 把 Mock 数据替换为 `URLSession` / `Alamofire` 请求
2. `ChatViewModel.sendMessage()` → 调用后端 `/api/chat`
3. `AppIconPlaceholder` → 替换为 `AsyncImage(url:)`
4. `EventCoverView` → 替换为 `AsyncImage(url:)`

---

## 设计系统

- **主色：** Indigo `#6366F1`
- **事件色：** Amber `#F59E0B`
- **成功色：** Emerald `#10B981`
- **背景：** iOS System Grouped Background（深浅模式自适应）
- **字体：** SF Pro Rounded（iOS 原生）
- **圆角：** 12 / 16 / 20 / 24px 四级
- **阴影：** 两层叠加，轻量感

---

## Mock 数据包含

- 4 个预置订阅（小众设计感 App / 深圳周末活动 / 独立游戏 / 上海艺术展览）
- 3 张 App 卡片（Mela / Camo / Pockity）
- 3 张活动卡片（星空音乐节 / 手作市集 / 大鹏骑行）
