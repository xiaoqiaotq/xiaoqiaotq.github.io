---
title: "React"
date: 2022-12-06T08:47:00+08:00
draft: false
tags: ["前端","react"]
---

https://zh-hans.reactjs.org/docs/handling-events.html

Babel 会把 JSX 转译成一个名为 React.createElement() 函数调用。

##### 组件名称必须以大写字母开头

React 会将以小写字母开头的组件视为原生 DOM 标签。例如，`<div />` 代表 HTML 的 div 标签，而 `<Welcome />` 则代表一个组件

##### Props 的只读性

```
// Wrong
this.setState({
  counter: this.state.counter + this.props.increment,
});

// Correct
this.setState(function(state, props) {
  return {
    counter: state.counter + props.increment
  };
});
```

#### 事件

```
<button onClick={(e) => this.deleteRow(id, e)}>Delete Row</button>
<button onClick={this.deleteRow.bind(this, id)}>Delete Row</button>
```

#### 条件渲染

##### 与运算符 &&

##### 三目运算符

```
The user is <b>{isLoggedIn ? 'currently' : 'not'}</b> logged in.

{isLoggedIn
        ? <LogoutButton onClick={this.handleLogoutClick} />
        : <LoginButton onClick={this.handleLoginClick} />
      }
```

##### 阻止组件渲染

render直接 return null

#### 列表 & Key

