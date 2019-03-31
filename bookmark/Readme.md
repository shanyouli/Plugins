# bookmark 说明

## 包含文件

- [bookmarks.bash](./bookmarks.bash) - main
- [bookmarks_completions.bash](./bookmarks_completions.bash) - completions

## 原理 - 四个函数

### `mark`: 使用 *ln* 将所有需要设置成书签的文件夹的软链接到同一个文件夹($MARKPATH)

### `jump`: *cp -P* 的方式打开($MARKPATH)文件夹下软连接的原文件夹

### `unmark`: *rm* 删除选定书签的软链接

### `marks`: 列出所用书签的原文件夹

## 更新

### 2019.03.31

- 修复 `jump` 和 `unmark` 需要按两次 `Return` 键的漏洞
- 修复, 当使用 `jump` 和 `unmark` 时,若同时存在 *$1* 和 **fzf or percol or peco** 的逻辑问题

### 2019.03.30 

- 添加对 `fzf` 或者 `peco` 或者 `percol` 等选择过滤工具的支持

