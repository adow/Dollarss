Dollarss
========

An Instant Message Client by XMPP on iPhone

使用XMPP实现的iPhone上的聊天工具。

只完成了一小部分功能。

* 登录和注册;
* 获取联系人列表;
* 添加好友;
* 接受好友;
* 与好友聊天;
* 获取多人聊天房间列表;
* 加入房间;
* 房间内多人聊天;
* 修改个人状态;


![群组聊天](https://farm8.staticflickr.com/7276/13801145794_ab25db30bd.jpg)
![群组](https://farm3.staticflickr.com/2818/13800802655_790c0154e9.jpg)

![状态](https://farm4.staticflickr.com/3680/13800821973_64182b21d9.jpg)
![好友聊天](https://farm6.staticflickr.com/5116/13800802835_f98bedca6e.jpg)

## 目录结构
* /Drrr: 封装XMPP Framework,实现具体功能;
* /Dollarss: 实现iPhone客户端界面;
* /XMPPFramework

## 项目依赖
* XMPPFramework: 只使用了Core功能，extensions只使用了Reconnect;
* 项目本身没有使用CoreData;
* 不支持arc;

## Drrr
包括几个主要的部分 

### 链接
* `DRRRManager`: 一个单实例,通过 [DRRRManager sharedManager]获取，用来管理和Jaber服务器的链接，发送xml数据等。 DRRRManager被其他各个功能模块使用。

### 消息:

* `DRRRMessageContent`:一个消息的条目(Message)，对应XMPPMessage
* `DRRRMessage`:整个消息列表，包括和每个联系人（聊天房间）的对话列表，DRRRMessage是一个单实例，通过[DRRRMessage sharedMessage]获取，他里面是一个messageBundle的NSDictionary,聊天者的jid就是key,value就是对话内容的列表，列表中是每一条消息，也就是DRRRMessageContent;接收到的好友邀请和房间邀请也是一个message content; 通过DRRRMessage 来发送消息。

### 联系人
* `DRRRRoster`：是整个联系人列表，他是一个单实例，通过[DRRRRoster sharedRoster]获取。通过DRRRRoster来获取联系人信息，修改当前登录用户的状态，订阅和接受联系人邀请；
* `DRRRRosterMember`:一个联系人条目;

### 聊天室
* `DRRRChatRoomManager`：一个单实例，通过[DRRRChatRoomManager sharedChatRoomManager]获取，他负责管理聊天室功能各个具体操作；
* `DRRRChatRoom`:对应一个聊天室的房间，包括一个成员列表memberList,和房间信息chatRoomInfo;
* `DRRRChatRoomInfo`: 一个聊天室的信息，包括一个NSArray 的features，和 NSDictionary的fields; 
* `DRRRChatRoomInfoField`: DRRRChatRoomInfo中fields中的每一个value都是一个DRRRChatRoomInfoField, 这样的结果只是为了对应XMPP返回来的数据格式；
* `DRRRChatRoomMember`: 一个聊天室成员，包括角色，状态等;