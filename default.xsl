<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output
     method="html"
     doctype-public="XSLT-compat"
     encoding="UTF-8"
     />

  <xsl:param name="filename"/>

  <!-- Copy all html4 elements over to the resulting html page -->
  <xsl:template match=" a | abbr | acronym | address | applet | area | b | base | basefont |
                       bdo | big | blockquote  | body | br | button | caption | center | cite | code | col |
                       colgroup | dd | del | dfn | dir | div | dl | dt | em | embed | fieldset     | font | form |
                       frame | frameset | h1 | h2 | h3 | h4 | h5 | h6 | head | hr | html | i | iframe | img |
                       input | ins | isindex    | kbd | label | legend | li | link | map | menu | meta |
                       noframes | noscript | object | ol | optgroup | option | p     | param | pre | q | s |
                       samp | script | select | small | span | strike | strong | style | sub | sup | table |
                       tbody | td | textarea | tfoot | th | thead | title | tr | tt | u | ul | var">

    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="." />
  </xsl:template>

  <!-- Error out on all unknown tags -->
  <xsl:template match="*">
    <xsl:message terminate="yes">
      <xsl:text>Found unknown tag: </xsl:text>
      <xsl:text>"</xsl:text><xsl:value-of select="name()"/><xsl:text>"</xsl:text>
      <xsl:value-of select="." />
    </xsl:message>
  </xsl:template>

  <xsl:template match="dlink">
    <a href="{@href}"><xsl:value-of select="@href" /></a>
  </xsl:template>

  <xsl:template match="menu">
    <ul>
      <xsl:apply-templates />
    </ul>
  </xsl:template>

  <xsl:template match="menu/item">
    <xsl:param name="name"/>

    <xsl:choose>
      <xsl:when test="$filename = @name">
        <li><a class="menuitemcurrent menuitem" href="{@name}.html"><xsl:value-of select="."/></a></li>
      </xsl:when>
      <xsl:otherwise>
        <li><a class="menuitem" href="{@name}.html"><xsl:value-of select="."/></a></li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="page">
    <html>
      <head>
        <title>Pingus - <xsl:value-of select="@title" /></title>
        <link rel="stylesheet" type="text/css" href="default.css" />
        <link rel="alternate stylesheet" title="Desert Theme" type="text/css" href="halloween.css" />
        <link rel="alternate stylesheet" title="Desert Theme" type="text/css" href="desert.css" />
        <link rel="alternate stylesheet" title="Snow Theme" type="text/css" href="snow.css" />
        <link rel="alternate stylesheet" title="X-Mas Theme" type="text/css" href="xmas.css" />
        <link rel="shortcut icon" href="images/favicon.png" type="image/png" />
      </head>
      <body>
        <div id="logo">
          <a href="http://pingus.seul.org"><img src="images/logo_pingus.png" alt="Pingus" /></a>
        </div>

        <div id="page">
          <div id="nav">
            <xsl:apply-templates select="document('menu.xml')" />
          </div>

          <div id="header">
            <h1><xsl:value-of select="@title"/></h1>
          </div>

          <div id="body">
            <xsl:apply-templates />
          </div>

          <div id="footer">
            Copyright &#169; 1998-2015
            <a href="http://grumbel.blogspot.co.at/">Ingo Ruhnke</a>
            &lt;<a href="mailto:grumbel@gmail.com">grumbel@gmail.com</a>&gt;
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="section">
    <h2><xsl:value-of select="@title" /></h2>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="subsection">
    <h3><xsl:value-of select="@title" /></h3>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="screenshots">
    <table width="100%" border="0" cellpadding="0"  cellspacing="0">
      <tr>
        <td style="text-align: center;">
          <xsl:apply-templates select="item[1]"/>
        </td>
        <td style="text-align: center;">
          <xsl:apply-templates select="item[2]"/>
        </td>
        <td style="text-align: center;">
          <xsl:apply-templates select="item[3]"/>
        </td>
      </tr>

      <xsl:if test="count(item)>3">
        <tr>
          <td style="text-align: center;">
            <xsl:apply-templates select="item[4]"/>
          </td>
          <td style="text-align: center;">
            <xsl:apply-templates select="item[5]"/>
          </td>
          <td style="text-align: center;">
            <xsl:apply-templates select="item[6]"/>
          </td>
        </tr>
      </xsl:if>

      <xsl:if test="count(item)>6">
        <tr>
          <td style="text-align: center;">
            <xsl:apply-templates select="item[7]"/>
          </td>
          <td style="text-align: center;">
            <xsl:apply-templates select="item[8]"/>
          </td>
          <td style="text-align: center;">
            <xsl:apply-templates select="item[9]"/>
          </td>
        </tr>
      </xsl:if>
    </table>
  </xsl:template>

  <xsl:template match="screenshots/item">
    <a href="images/{@file}.jpg"><img class="screenshot" alt="{@file}" src="images/{@file}_small.jpg" title="{.}"/></a>
  </xsl:template>

  <xsl:template match="screenshot-menu">
    <div class="screenshotmenu-center">
    <ul class="screenshotmenu">
      <li><a href="videos.html">Videos</a></li>
      <!-- <li><a href="screenshots.html">0.8</a></li> -->
      <li><a href="screenshots-0.7.html">0.7</a></li>
      <li><a href="screenshots-0.6.html">0.6</a></li>
      <li><a href="screenshots-0.5.html">0.5</a></li>
      <li><a href="screenshots-0.4.html">0.4</a></li>
      <li><a href="screenshots-0.3.html">0.3</a></li>
      <li><a href="screenshots-0.2.html">0.2</a></li>
      <li><a href="screenshots-0.1.html">0.1</a></li>
      <li><a href="screenshots-0.0.html">0.0</a></li>
    </ul>
    </div>
  </xsl:template>

  <xsl:template match="section-toc">
    <ul>
      <xsl:for-each select="section">
        <li><a href="#section{generate-id(.)}">
            <xsl:apply-templates/></a></li>
      </xsl:for-each>
    </ul>
    <hr/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="faq-list">
    <ul>
      <xsl:for-each select="faq/question">
        <li><a href="#faq{generate-id(.)}">
            <xsl:apply-templates/></a></li>
      </xsl:for-each>
    </ul>

    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="faq">
    <div style="float: right;">
      <small><xsl:value-of select="@date"/></small>
      [<small><a href="#faqtoc">Up</a></small>]
    </div>
    <h3 id="faq{generate-id(question)}"><xsl:apply-templates select="question/node()"/></h3>
    <div class="answer"><xsl:apply-templates select="answer/node()"/></div>
  </xsl:template>

  <xsl:template match="news">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="news/item">
    <div class="newsitem">
      <div class="newsdate"><xsl:value-of select="@date"/></div>
      <div class="newsbody"><xsl:apply-templates/></div>
    </div>
  </xsl:template>

  <xsl:template match="german-flag">
    (german)
  </xsl:template>

  <xsl:template match="english-flag">
    (english)
  </xsl:template>

  <xsl:template match="dutch-flag">
    (dutch)
  </xsl:template>

</xsl:stylesheet>
