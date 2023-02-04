---
title: "Antlr4初学"
date: 2023-01-08T22:09:26+08:00
draft: false
tags: ["Antlr4","JAVA","DSL"]
cover:
    image: "https://cn.bing.com/th?id=OHR.QuebecFrontenac_ZH-CN9519096458_1920x1080.jpg&rf=LaDigue_1920x1080.jpg&pid=hp"
    hidden: true # only hide on current single page
---

#### 背景
项目需要实现前端任意字段匹配查询，故需要配合表达式来生产sql，其实就是定义一种DSL，让前后端相互了解这个语意，调研后决定使用Antlr，相关介绍就不过分多说，直接看效果。语法参考Odata filter ，后期不满足可以直接修改g4文件

#### Odata filter示例
```
Country_Region_Code eq 'ES' or Country_Region_Code eq 'US'
Country_Region_Code eq 'ES' and Payment_Terms_Code eq '14 DAYS'
Entry_No ge 610
Entry_No lt 610
VAT_Bus_Posting_Group ne 'EXPORT'
```

#### Odata.g4

```
grammar OData;

/*
 * Parser Rules
 */

program: expression;

expression:
	LP expression RP # Parenthesis
	| K_STARTSWITH LP column=column_name ',' value=TEXT RP # StartsWith
	| K_ENDSWITH LP column=column_name ',' value=TEXT RP # EndsWith
	| K_CONTAINS LP column=column_name ',' value=TEXT RP # Contains
	| column=column_name K_IN LP value=decimal_array RP # InDecimal
	| column=column_name K_IN LP value=string_array RP # InText
	| column=column_name compare=(
		Equal
		| NotEqual
		| GreaterThan
		| GreaterThanOrEqual
		| LessThan
		| LessThanOrEqual) value=decimal # CompareDecimal
	| column=column_name compare=(
		Equal
		| NotEqual
		| GreaterThan
		| GreaterThanOrEqual
		| LessThan
		| LessThanOrEqual) value=TEXT # CompareText
	| expression logic = (K_AND | K_OR) expression	# Logic
	;

column_name
   : COLUMN_NAME
   | '[' column_name ']'
   ;

string_array
	: TEXT (',' TEXT)*
	;

decimal_array
	: NUMBER (',' NUMBER)*
	;

text: TEXT;

decimal
	: NUMBER
	;

/*
 * Lexer Rules
 */

K_IN: I N;
K_AND: A N D;
K_OR: O R;
K_STARTSWITH: S T A R T S W I T H;
K_ENDSWITH: E N D S W I T H;
K_CONTAINS: C O N T A I N S;
LP : '(';
RP : ')';

Equal: E Q;
NotEqual: N E;
GreaterThan: G T;
GreaterThanOrEqual: G E;
LessThan: L T;
LessThanOrEqual: L E;

COLUMN_NAME
   : VALID_ID_START VALID_ID_CHAR*
   ;

TEXT
	:'"' .*? '"'
	|'\'' .*? '\''
	;

NUMBER
   : (SIGN)? UNSIGNED_INTEGER+
   | (SIGN)? UNSIGNED_INTEGER+ ('.' UNSIGNED_INTEGER+)?
   ;

fragment UNSIGNED_INTEGER
   : ('0' .. '9')
   ;

fragment SIGN
   : ('+' | '-')
   ;

fragment VALID_ID_START
   : LOWERCASE | UPERCASE | '_'
   ;

fragment VALID_ID_CHAR
   : VALID_ID_START | (LOWERCASE | UPERCASE | DIGIT )
   ;

fragment LOWERCASE: [a-z];
fragment UPERCASE: [A-Z];

fragment DIGIT: [0-9];
fragment DIGITS: DIGIT+;
fragment A: [aA];
fragment B: [bB];
fragment C: [cC];
fragment D: [dD];
fragment E: [eE];
fragment F: [fF];
fragment G: [gG];
fragment H: [hH];
fragment I: [iI];
fragment J: [jJ];
fragment K: [kK];
fragment L: [lL];
fragment M: [mM];
fragment N: [nN];
fragment O: [oO];
fragment P: [pP];
fragment Q: [qQ];
fragment R: [rR];
fragment S: [sS];
fragment T: [tT];
fragment U: [uU];
fragment V: [vV];
fragment W: [wW];
fragment X: [xX];
fragment Y: [yY];
fragment Z: [zZ];

SPACES: [ \u000B\t\r\n] -> channel(HIDDEN);

```


#### 前端

##### UI

![WX20230204-203415@2x.png](https://s2.loli.net/2023/02/04/yraYmPKxQGb1d7j.png)

##### npm包
`
npm i antlr4@4.11.0
`

##### Visitor（DSL to js）

```

// This class defines a complete generic visitor for a parse tree produced by ODataParser.

import ODataParser from "@/project/antlr/ODataParser";
import ODataVisitor from "@/project/antlr/ODataVisitor";

export default class ODataSqlVisitor extends ODataVisitor {

	filterPair={
		logic:'AND',
		pairs:[]
	}

	getFilterPair(){
		return this.filterPair
	}
	// Visit a parse tree produced by ODataParser#CompareText.
	visitCompareText(ctx) {
		if (ctx.exception!=null) {
			throw  ctx.exception;
		}
		const column = this.visit(ctx.column);
		const decimal= ctx.value.text.replace(/^"(.*)"$/,"$1")
		const operator = this.getSQLOperator(ctx.compare.type);
		const pair= {column ,value: decimal,operator};
		this.filterPair.pairs.push(pair)
		return pair;
	}



	// Visit a parse tree produced by ODataParser#CompareDecimal.
	visitCompareDecimal(ctx) {
		if (ctx.exception!=null) {
			throw  ctx.exception;
		}
		const column = this.visit(ctx.column);
		const decimal = this.visit(ctx.value);
		const operator = this.getSQLOperator(ctx.compare.type);
		// return column + " " + operator + " " + decimal;
		const pair= {column ,value: decimal,operator};
		this.filterPair.pairs.push(pair)
		return pair;
	}


	// Visit a parse tree produced by ODataParser#Logic.
	visitLogic(ctx){
		if(ctx.exception!=null) {
			throw  ctx.exception;
		}
		const left = this.visit(ctx.expression(0));
        const right = this.visit(ctx.expression(1));
		if (right == null){
			return null;
		}
		if (ctx.logic.type== ODataParser.K_AND) {
			this.filterPair.logic = "AND";
			// return left + " and " + right;
			return null;
		}else {
			this.filterPair.logic = "OR";
			// return left + " or " + right;
			return null;
		}
	}




	// Visit a parse tree produced by ODataParser#column_name.
	visitColumn_name(ctx) {
		return ctx.getText();
	}


	// Visit a parse tree produced by ODataParser#decimal.
	visitDecimal(ctx) {
		return ctx.getText();
	}

	// visitText(ctx) {
	// 	const aa= ctx.getText().replace(/^"(.*)"$/,"$1")
	// 	console.log(aa,ctx.getText())
	// 	debugger
	// 	return aa
	// }

	getSQLOperator(compare) {
		let operator = null;
		switch (compare) {
			case ODataParser.Equal:
				operator = "=";
				break;
			case ODataParser.NotEqual:
				operator = "<>";
				break;
			case ODataParser.GreaterThan:
				operator = ">";
				break;
			case ODataParser.GreaterThanOrEqual:
				operator = ">=";
				break;
			case ODataParser.LessThan:
				operator = "<";
				break;
			case ODataParser.LessThanOrEqual:
				operator = "<=";
				break;
		}
		return operator;
   }

}
```



#### 后端
##### maven坐标
```
<!-- https://mvnrepository.com/artifact/org.antlr/antlr4-runtime -->
<dependency>
    <groupId>org.antlr</groupId>
    <artifactId>antlr4-runtime</artifactId>
    <version>4.11.1</version>
</dependency>
```

##### Visitor（DSL to sql） 和工具类

```
package com.sankyu.wms.antlr;


import com.google.common.base.CaseFormat;

public class ODataSqlVisitor extends ODataBaseVisitor {
  @Override
  public Object visitLogic(ODataParser.LogicContext ctx) {
    if (ctx.exception!=null) {
      throw  ctx.exception;
    }
    String left = (String) visit(ctx.expression(0));
    String right = (String) visit(ctx.expression(1));
    if (right == null){
      return null;
    }
    if (ctx.logic.getType()==ODataParser.K_AND) {
      return left + " and " + right;
    }else {
      return left + " or " + right;
    }
  }

  @Override
  public Object visitColumn_name(ODataParser.Column_nameContext ctx) {
    return CaseFormat.UPPER_CAMEL.to(CaseFormat.LOWER_UNDERSCORE, ctx.getText());
  }

  @Override
  public Object visitDecimal(ODataParser.DecimalContext ctx) {
    return ctx.getText();
  }

//  @Override
//  public Object visitText(ODataParser.TextContext ctx) {
//    return ctx.getText();
//  }

  @Override
  public Object visitCompareDecimal(ODataParser.CompareDecimalContext ctx) {
    if (ctx.exception!=null) {
      throw  ctx.exception;
    }
    String column = (String)visit(ctx.column);
    String decimal = (String)visit(ctx.value);
    String operator = getSQLOperator(ctx.compare.getType());
    return column + " " + operator + " " + decimal;
  }


  @Override
  public Object visitCompareText(ODataParser.CompareTextContext ctx) {
    if (ctx.exception!=null) {
      throw  ctx.exception;
    }
    String column = (String)visit(ctx.column);
    String decimal = ctx.value.getText();
    String operator = getSQLOperator(ctx.compare.getType());
    return column + " " + operator + " " + decimal;
  }


  private String getSQLOperator(Integer compare) {
    String operator = null;
    switch (compare) {
      case ODataParser.Equal:
        operator = "=";
        break;
      case ODataParser.NotEqual:
        operator = "<>";
        break;
      case ODataParser.GreaterThan:
        operator = ">";
        break;
      case ODataParser.GreaterThanOrEqual:
        operator = ">=";
        break;
      case ODataParser.LessThan:
        operator = "<";
        break;
      case ODataParser.LessThanOrEqual:
        operator = "<=";
        break;
    }
    return operator;
  }
}

```


#### 参考

1. https://olingo.apache.org/doc/odata2/tutorials/Olingo_Tutorial_AdvancedRead_FilterVisitor.html
2. https://blog.51cto.com/u_15067225/2603738
3. https://learn.microsoft.com/en-us/dynamics-nav/using-filter-expressions-in-odata-uris
4. https://github.com/huazailmh/ODataFilterParser/blob/master/Parser/ODataFilterVisitor.cs