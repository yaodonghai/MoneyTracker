# MoneyTracker - iOS记账应用

## 项目概述

MoneyTracker是一款基于Swift开发的iOS记账应用，采用纯代码方式（UIKit）开发，不使用SwiftUI。应用专注于简洁美观的界面设计和流畅的用户体验，帮助用户轻松管理个人财务。

## 技术栈

- **开发语言**: Swift 5.0+
- **UI框架**: UIKit (纯代码，不使用Storyboard/XIB)
- **最低支持版本**: iOS 13.0
- **数据库**: SQLite (通过FMDB封装)
- **依赖管理**: CocoaPods
- **架构模式**: MVC + 单例模式

## 需求文档

### 1. 核心功能需求

#### 1.1 用户账号管理
- **账号注册/登录**
  - 支持用户名+密码注册
  - 支持账号登录
  - 本地存储用户凭证（使用Keychain）
  - 支持多账号切换
  - 账号数据隔离（每个账号独立数据库）

- **账号切换**
  - 在设置页面显示当前登录账号
  - 支持快速切换账号
  - 切换账号时保存当前数据，加载新账号数据
  - 显示账号列表，支持添加/删除账号

#### 1.2 记账功能
- **快速记账**
  - 收入/支出类型选择
  - 金额输入（支持小数点）
  - 分类选择（预设分类 + 自定义分类）
  - 备注信息（可选）
  - 日期时间选择（默认当前时间）
  - 账户选择（现金、银行卡、支付宝、微信等）

- **记账记录管理**
  - 列表展示所有记账记录
  - 支持按日期、类型、分类筛选
  - 支持编辑已记账记录
  - 支持删除记账记录
  - 支持批量操作

#### 1.3 分类管理
- **预设分类**
  - 支出分类：餐饮、交通、购物、娱乐、医疗、教育、住房、其他
  - 收入分类：工资、奖金、投资、兼职、其他

- **自定义分类**
  - 支持添加自定义分类
  - 支持编辑分类名称
  - 支持删除分类（需处理已有记录的分类）
  - 支持分类图标（文字标识）

#### 1.4 账户管理
- **账户类型**
  - 现金
  - 银行卡
  - 支付宝
  - 微信
  - 信用卡
  - 其他

- **账户功能**
  - 添加账户
  - 编辑账户信息（名称、余额）
  - 删除账户
  - 查看账户余额
  - 账户间转账功能

#### 1.5 统计分析
- **概览统计**
  - 本月总收入/总支出
  - 本月结余
  - 支出趋势（折线图/柱状图）
  - 收入趋势（折线图/柱状图）

- **分类统计**
  - 支出分类占比（饼图）
  - 收入分类占比（饼图）
  - 各分类金额明细

- **时间统计**
  - 按日统计
  - 按周统计
  - 按月统计
  - 按年统计
  - 自定义时间段统计

#### 1.6 数据管理
- **数据导出**
  - 导出为CSV格式
  - 导出为Excel格式（可选）
  - 通过AirDrop、邮件等方式分享

- **数据备份与恢复**
  - 本地数据库备份
  - 数据恢复功能

- **数据清理**
  - 清空所有数据（需确认）
  - 按时间段删除数据

### 2. UI/UX需求

#### 2.1 设计原则
- **简洁美观**: 界面简洁，信息层次清晰
- **易于操作**: 核心功能快速访问，操作流程简单
- **视觉统一**: 统一的颜色主题和字体规范
- **纯文字设计**: 不使用图片资源，全部使用文字和图标字体

#### 2.2 颜色主题
- **主色调**: 
  - 主色：#007AFF（iOS蓝）或 #34C759（绿色，代表收入）
  - 辅助色：#FF3B30（红色，代表支出）
  - 背景色：#F2F2F7（浅灰）
  - 卡片背景：#FFFFFF（白色）
  - 文字主色：#000000（黑色）
  - 文字次色：#8E8E93（灰色）

- **深色模式支持**（可选）
  - 适配iOS深色模式

#### 2.3 页面结构
- **底部Tab导航**（4个主要模块）
  1. 首页（概览 + 快速记账）
  2. 记账记录
  3. 统计
  4. 设置

- **导航栏**
  - 统一的导航栏样式
  - 支持返回按钮
  - 标题居中显示

#### 2.4 主要页面
1. **首页**
   - 顶部：本月收支概览卡片
   - 中间：快速记账按钮
   - 底部：最近5条记账记录

2. **记账页面**
   - 金额输入键盘
   - 类型切换（收入/支出）
   - 分类选择器
   - 账户选择器
   - 日期选择器
   - 备注输入框

3. **记账记录列表页**
   - 按日期分组显示
   - 支持下拉刷新
   - 支持上拉加载更多
   - 左滑删除功能

4. **统计页面**
   - Tab切换（概览/分类/趋势）
   - 图表展示（使用第三方图表库）

5. **设置页面**
   - 账号管理
   - 分类管理
   - 账户管理
   - 数据导出
   - 关于

### 3. 数据库设计

#### 3.1 用户表 (users)
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    created_at TEXT NOT NULL
);
```

#### 3.2 账户表 (accounts)
```sql
CREATE TABLE accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    balance REAL DEFAULT 0.0,
    created_at TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

#### 3.3 分类表 (categories)
```sql
CREATE TABLE categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    type TEXT NOT NULL, -- 'income' or 'expense'
    icon TEXT, -- 文字图标
    is_system INTEGER DEFAULT 0, -- 0: 自定义, 1: 系统预设
    created_at TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

#### 3.4 记账记录表 (transactions)
```sql
CREATE TABLE transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    type TEXT NOT NULL, -- 'income' or 'expense'
    amount REAL NOT NULL,
    category_id INTEGER NOT NULL,
    account_id INTEGER NOT NULL,
    note TEXT,
    date TEXT NOT NULL,
    created_at TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);
```

### 4. 第三方库需求

#### 4.1 数据库操作
- **FMDB**: SQLite数据库封装，简化数据库操作

#### 4.2 UI组件
- **Charts**: 图表绘制库（用于统计页面）
- **SnapKit**: 自动布局库（简化代码布局）

#### 4.3 工具类
- **KeychainAccess**: 安全存储用户凭证
- **MBProgressHUD**: 加载提示框

#### 4.4 其他
- **IQKeyboardManager**: 键盘管理（可选）

## 开发计划

### 阶段一：项目基础搭建（1-2天）

#### 1.1 项目初始化
- [x] 创建Xcode项目
- [ ] 配置CocoaPods
- [ ] 创建Podfile并安装依赖库
- [ ] 配置项目基本信息（Bundle ID、版本号等）

#### 1.2 项目架构搭建
- [ ] 创建文件夹结构
  ```
  MoneyTracker/
  ├── Models/          # 数据模型
  ├── Views/           # 视图层
  ├── Controllers/     # 控制器层
  ├── Database/        # 数据库管理
  ├── Utils/           # 工具类
  ├── Extensions/      # 扩展
  └── Resources/       # 资源文件（颜色、字体等）
  ```
- [ ] 创建基础工具类（颜色、字体、尺寸等）
- [ ] 创建数据库管理类

#### 1.3 依赖库安装
- [ ] 安装FMDB
- [ ] 安装Charts
- [ ] 安装SnapKit
- [ ] 安装KeychainAccess
- [ ] 安装MBProgressHUD

### 阶段二：数据库层开发（2-3天）

#### 2.1 数据库初始化
- [ ] 创建DatabaseManager单例类
- [ ] 实现数据库创建和初始化
- [ ] 实现数据库表创建（users, accounts, categories, transactions）
- [ ] 实现数据库升级机制

#### 2.2 数据模型
- [ ] 创建User模型
- [ ] 创建Account模型
- [ ] 创建Category模型
- [ ] 创建Transaction模型

#### 2.3 数据访问层（DAO）
- [ ] UserDAO - 用户数据操作
- [ ] AccountDAO - 账户数据操作
- [ ] CategoryDAO - 分类数据操作
- [ ] TransactionDAO - 记账记录操作

### 阶段三：用户账号系统（2-3天）

#### 3.1 登录注册功能
- [ ] 创建登录页面（LoginViewController）
- [ ] 创建注册页面（RegisterViewController）
- [ ] 实现登录逻辑
- [ ] 实现注册逻辑
- [ ] 使用Keychain存储用户凭证
- [ ] 实现自动登录功能

#### 3.2 账号切换功能
- [ ] 在设置页面添加账号管理入口
- [ ] 创建账号列表页面（AccountListViewController）
- [ ] 实现账号切换逻辑
- [ ] 实现账号添加功能
- [ ] 实现账号删除功能（需确认）

### 阶段四：核心记账功能（3-4天）

#### 4.1 快速记账
- [ ] 创建记账页面（AddTransactionViewController）
- [ ] 实现金额输入键盘
- [ ] 实现收入/支出类型切换
- [ ] 实现分类选择器
- [ ] 实现账户选择器
- [ ] 实现日期选择器
- [ ] 实现备注输入
- [ ] 实现保存记账记录

#### 4.2 记账记录列表
- [ ] 创建记账记录列表页面（TransactionListViewController）
- [ ] 实现列表展示（按日期分组）
- [ ] 实现下拉刷新
- [ ] 实现上拉加载更多
- [ ] 实现左滑删除
- [ ] 实现记录编辑功能

#### 4.3 记账记录详情
- [ ] 创建详情页面（TransactionDetailViewController）
- [ ] 显示记录详细信息
- [ ] 实现编辑功能
- [ ] 实现删除功能

### 阶段五：分类和账户管理（2-3天）

#### 5.1 分类管理
- [ ] 创建分类管理页面（CategoryManagerViewController）
- [ ] 实现预设分类初始化
- [ ] 实现分类列表展示
- [ ] 实现添加分类功能
- [ ] 实现编辑分类功能
- [ ] 实现删除分类功能

#### 5.2 账户管理
- [ ] 创建账户管理页面（AccountManagerViewController）
- [ ] 实现账户列表展示
- [ ] 实现添加账户功能
- [ ] 实现编辑账户功能（包括余额）
- [ ] 实现删除账户功能
- [ ] 实现账户间转账功能

### 阶段六：统计功能（3-4天）

#### 6.1 概览统计
- [ ] 创建统计页面（StatisticsViewController）
- [ ] 实现本月收支统计
- [ ] 实现结余计算
- [ ] 实现收支趋势图表（使用Charts库）

#### 6.2 分类统计
- [ ] 实现支出分类占比饼图
- [ ] 实现收入分类占比饼图
- [ ] 实现分类金额明细列表

#### 6.3 时间统计
- [ ] 实现按日统计
- [ ] 实现按周统计
- [ ] 实现按月统计
- [ ] 实现按年统计
- [ ] 实现自定义时间段统计

### 阶段七：首页和导航（2-3天）

#### 7.1 首页开发
- [ ] 创建首页（HomeViewController）
- [ ] 实现本月收支概览卡片
- [ ] 实现快速记账按钮
- [ ] 实现最近记账记录列表
- [ ] 实现下拉刷新

#### 7.2 Tab导航
- [ ] 创建主TabBarController
- [ ] 配置4个主要Tab页面
- [ ] 实现Tab切换逻辑
- [ ] 自定义TabBar样式

### 阶段八：设置和数据管理（2-3天）

#### 8.1 设置页面
- [ ] 创建设置页面（SettingsViewController）
- [ ] 实现账号管理入口
- [ ] 实现分类管理入口
- [ ] 实现账户管理入口
- [ ] 实现数据导出入口
- [ ] 实现关于页面

#### 8.2 数据导出
- [ ] 实现CSV导出功能
- [ ] 实现数据分享功能（AirDrop、邮件等）

#### 8.3 数据备份恢复
- [ ] 实现数据库备份功能
- [ ] 实现数据恢复功能

### 阶段九：UI优化和细节完善（2-3天）

#### 9.1 UI美化
- [ ] 统一颜色主题
- [ ] 统一字体规范
- [ ] 优化卡片样式
- [ ] 优化按钮样式
- [ ] 优化输入框样式

#### 9.2 交互优化
- [ ] 添加加载动画
- [ ] 添加成功/失败提示
- [ ] 优化键盘弹出处理
- [ ] 优化页面转场动画

#### 9.3 错误处理
- [ ] 添加数据验证
- [ ] 添加错误提示
- [ ] 处理异常情况

### 阶段十：测试和优化（2-3天）

#### 10.1 功能测试
- [ ] 测试所有核心功能
- [ ] 测试边界情况
- [ ] 测试数据一致性

#### 10.2 性能优化
- [ ] 优化数据库查询
- [ ] 优化列表滚动性能
- [ ] 优化内存使用

#### 10.3 Bug修复
- [ ] 修复发现的问题
- [ ] 优化用户体验

## 项目文件结构

```
MoneyTracker/
├── MoneyTracker/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── Models/
│   │   ├── User.swift
│   │   ├── Account.swift
│   │   ├── Category.swift
│   │   └── Transaction.swift
│   ├── Database/
│   │   ├── DatabaseManager.swift
│   │   ├── UserDAO.swift
│   │   ├── AccountDAO.swift
│   │   ├── CategoryDAO.swift
│   │   └── TransactionDAO.swift
│   ├── Controllers/
│   │   ├── Main/
│   │   │   └── MainTabBarController.swift
│   │   ├── Home/
│   │   │   └── HomeViewController.swift
│   │   ├── Transaction/
│   │   │   ├── AddTransactionViewController.swift
│   │   │   ├── TransactionListViewController.swift
│   │   │   └── TransactionDetailViewController.swift
│   │   ├── Statistics/
│   │   │   └── StatisticsViewController.swift
│   │   ├── Settings/
│   │   │   ├── SettingsViewController.swift
│   │   │   ├── AccountListViewController.swift
│   │   │   ├── CategoryManagerViewController.swift
│   │   │   └── AccountManagerViewController.swift
│   │   └── Auth/
│   │       ├── LoginViewController.swift
│   │       └── RegisterViewController.swift
│   ├── Views/
│   │   ├── Cells/
│   │   │   ├── TransactionCell.swift
│   │   │   ├── CategoryCell.swift
│   │   │   └── AccountCell.swift
│   │   └── Components/
│   │       ├── AmountInputView.swift
│   │       └── CategoryPickerView.swift
│   ├── Utils/
│   │   ├── ColorTheme.swift
│   │   ├── FontManager.swift
│   │   └── DateHelper.swift
│   └── Extensions/
│       ├── UIView+Extension.swift
│       └── String+Extension.swift
├── Podfile
├── Podfile.lock
└── README.md
```

## 开发规范

### 代码规范
- 使用Swift命名规范（驼峰命名）
- 类名使用大驼峰（PascalCase）
- 变量和方法名使用小驼峰（camelCase）
- 常量使用大写下划线分隔（UPPER_SNAKE_CASE）

### 注释规范
- 每个类添加类注释说明用途
- 复杂方法添加注释说明逻辑
- 使用MARK注释分组代码

### Git提交规范
- feat: 新功能
- fix: 修复bug
- docs: 文档更新
- style: 代码格式调整
- refactor: 代码重构
- test: 测试相关
- chore: 构建/工具相关

## 预计开发时间

总计：**20-30个工作日**

- 项目搭建：1-2天
- 数据库层：2-3天
- 用户系统：2-3天
- 记账功能：3-4天
- 分类账户管理：2-3天
- 统计功能：3-4天
- 首页导航：2-3天
- 设置数据管理：2-3天
- UI优化：2-3天
- 测试优化：2-3天

## 后续优化方向

1. **深色模式支持**
2. **数据云同步**（iCloud）
3. **预算功能**
4. **账单提醒**
5. **多币种支持**
6. **数据可视化增强**
7. **Widget小组件**
8. **Apple Watch支持**

## 参考资料

- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [FMDB文档](https://github.com/ccgus/fmdb)
- [Charts文档](https://github.com/danielgindi/Charts)
- [SnapKit文档](https://github.com/SnapKit/SnapKit)

---

**最后更新**: 2026年2月20日
