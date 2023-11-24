# 背景
   《死神激斗》是一款我比较喜欢的格斗类游戏，在2020年7月～2021年6月之间，这款游戏跟其微信游戏公众号之间互通：有游戏日常活跃度满足条件以后可领取转盘娃娃的游戏基础积分，这个积分可以累计。而转盘游戏会通过消耗基础积分获得游戏内环或者转盘娃娃道具（公众号道具）。我发现了这个转盘游戏有一个规则漏洞：转盘游戏在获得游戏内道具--环的时候会给游戏内发一个游戏邮件，当游戏处于维护状态的情况下因为游戏邮件发送失败而把转盘旋转失败的消耗积分返还。我们可以利用这个规则进行只刷公众号转盘游戏道具而不刷游戏内道具的方式获取更多的收益。因为游戏通常只会维护30分钟，如果累计的分数很多，根本刷不玩累计的积分，这个时候我就想到了程序的力量。

# 目标
   使用程序的力量，提升刷道具的效率。本着学习Dart语言的态度，用Flutter实现这个刷分流程。这样编译过的App可以在iOS上使用，同时也能在Android上使用，实现跨端目标。

# 行动  
   1、通过使用Charles抓包微信公众号的转盘游戏中的API，得到以下列表：
   ` 
    ///基本API地址
    static const String BL_BASE_URL = "https://h5.mobage.cn/bl2/cn_bl2_doll_machine/api/active/";
    ///TOKEN
    static const String BL_WX_TOKEN = "m5PI6y/SsFsmH5fCslcS+kU/OTH9BOASTHKr7dIT9OnTr0jtf8kSDVbJOX1JiFywdxlifmw+i7hFhx5DFj1dYxvrPriAphvI/WTvbkUshk2gbbKe5T4AIrKT5AkFbnVm";
    ///登陆API
    static const String BL_USER_LOGIN = "/player/login";
    ///绑定角色关系
    static const String BL_USER_BIND_ROLE = "player/bindingServer";
    ///登陆账号
    static const String BL_USER_LOGOUT = "/player/logout";
    ///账号下的游戏角色信息
    static const String BL_SERVER_LIST = "/player/getServerList";
    ///获取游戏角色的积分内容
    static const String BL_GET_POINT = "/playerItem/getPoint";
    ///获取娃娃接口
    static const String BL_GET_DOLL = "/playerItem/getGashapon";
    ///获取已经获得的娃娃数据接口
    static const String BL_USER_DOLL_INFO = "/playerItem/getItemInfo";
    ///兑换娃娃接口
    static const String BL_GET_CRYSTAL = "/playerItem/exchangeItem";
    ///转盘
    static const String BLZP_BASE_URL = "https://h5-bl2-https.mobage.cn/bl2dailydraw/";
    ///微信openId
    static const String BLZP_WX_OPEN_ID = "oDRfo0ZtRcduE4TUI55x6PFE_QOQ";
    ///登陆API
    static const String BLZP_USER_LOGIN = "/sys/login";
    ///账号下的角色列表
    static const String BLZP_SERVER_LIST = "/binding/getSystem";
    ///绑定角色关系
    static const String BLZP_USER_BIND_ROLE = "/binding/bindingRegion";
    ///获取用户信息
    static const String BLZP_USER_BASEINFO = "/binding/getBaseInfo";
    ///登陆账号
    static const String BLZP_USER_LOGOUT = "/sys/logout";
    ///获取游戏角色的积分内容
    static const String BLZP_GET_CHAGNE = "/draw/getChance";
    ///转盘使用
    static const String BLZP_USE_CHNAGE = "/draw/dailyDraw";
    `
    2、通过之前手动刷分的路径还原API的操作路径，并且使用Dart语言业务代码完成刷分过程并且打印刷分步骤的信息。
   自动领取活跃度的路径：
    
    帐号登录 -> 获取绑定角色服务器 
        ^          |
        |          V
      切换帐号 <- 自动领取活跃度积分
      
   刷分路径：
    
    帐号登录-> 获取绑定角色服务器-> 输入要刷到的娃娃数量-> 刷娃娃进程-> 异常流程退出。
    
   3、通过实际使用体验，不断改进需求逻辑，发挥程序员的价值。

# 结果
   
   通过App的使用，把原本刷分1000积分至少需要50分钟的时间的需求，变成在60s内完成刷分需求，且还能制定道具。


