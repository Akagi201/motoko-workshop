import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Debug "mo:base/Debug";

actor {
  public type Message = {
    text : Text;
    time : Time.Time;
    author : Text;
  };

  public type Microblog = actor {
    // 添加关注对象
    follow : shared (Principal) -> async ();
    // 返回关注列表
    follows : shared query () -> async [Principal];
    // 发布新消息
    post : shared (Text, Text) -> async ();
    // 返回所有发布的消息
    posts : shared query (Time.Time) -> async [Message];
    // 返回所有关注对象发布的消息
    timeline : shared ([Principal], Time.Time) -> async [Message];
    // 设置作者名称
    set_name : shared (Text, Text) -> async ();
    // 获取作者名称
    get_name : shared query () -> async ?Text;
  };

  stable var name : Text = "Akagi201";
  stable var followed : List.List<(Principal, Text)> = List.nil();
  stable var messages : List.List<Message> = List.nil();

  public shared func follow(id : Principal) : async () {
    let canister : Microblog = actor (Principal.toText(id));
    let author : Text = switch (await canister.get_name()) {
      case null "No author";
      case (?Text) Text;
    };
    followed := List.push((id, author), followed);
  };

  public shared query func follows() : async [(Principal, Text)] {
    List.toArray(followed);
  };

  public shared (msg) func post(text : Text, otp : Text) : async (Time.Time) {
    Debug.print(debug_show (Principal.toText(msg.caller)));
    assert (otp == "123456"); // simple password check
    // 限制调用方必须为自己: dfx identity get-principal
    // assert(Principal.toText(msg.caller) =="o7tmu-26wam-t3utw-l5jsi-3qpco-s3hoy-wk5io-yt4o7-7o3yg-r62gb-bqe");
    let now = Time.now();
    let new_post : Message = {
      text = text;
      time = now;
      author = name;
    };
    messages := List.push(new_post, messages);
    now;
  };

  public shared query func posts(since : Time.Time) : async [Message] {
    let since_msg = List.filter(
      messages,
      func(msg : Message) : Bool {
        msg.time > since;
      },
    );
    List.toArray(since_msg);
  };

  public shared func timeline(authors : [Principal], since : Time.Time) : async [Message] {
    var msgList : List.List<Message> = List.nil();
    var authorList : List.List<Principal> = List.nil();

    let getId = func((id : Principal, name : Text)) : Principal {
      id;
    };

    // 获取作者列表, 空表示所有关注者
    if (authors.size() == 0) {
      authorList := List.map(followed, getId);
    } else {
      authorList := List.fromArray(authors);
    };

    // 根据作者获取消息
    for (id in Iter.fromList(authorList)) {
      let canister : Microblog = actor (Principal.toText(id));
      let msgs = await canister.posts(since);
      for (msg in Iter.fromArray(msgs)) {
        msgList := List.push(msg, msgList);
      };
    };

    List.toArray(msgList);
  };

  public shared func set_name(author : Text, otp : Text) : async () {
    assert (otp == "123456"); // simple password check
    name := author;
  };

  public shared query func get_name() : async ?Text {
    ?name;
  };
};
