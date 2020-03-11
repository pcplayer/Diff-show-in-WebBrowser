一个简单的用 Delphi 写的文本差异检查及显示的程序的源代码。

pcplayer 2018-10-13


文本差异采用 Diff.pas 来解析。

差异的显示，采用 HTML 的格式。这样方便给差异的文本添加背景色。

HTML 格式采用 BootStrap 框架。所需的 css, js 文件都在 win32/debug 目录下。也就是和可执行文件在同一个目录下。


工作原理：

程序要显示文本内容，将文本内容处理过后，加载模板页面，将文本内容替换掉模板文件的 <##> 部分，然后保存为一个 html 文件，然后用浏览器去打开它。这个 html 文件相同目录下，必须要有 BootStrap 框架相关的 css 和 js 文件。

-------------------------------

using diff.pas to get diff result,
using bootstrap to format the show the result of diff.