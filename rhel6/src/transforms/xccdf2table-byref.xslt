<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:cdf="http://checklists.nist.gov/xccdf/1.1">

<!-- this style sheet expects parameter $ref, which is the abbreviation of the ref to be shown -->

<xsl:include href="constants.xslt"/>

	<xsl:template match="/">
		<html>
		<head>
			<title> Rules with <xsl:value-of select="$ref"/> Reference in <xsl:value-of select="/cdf:Benchmark/cdf:title" /> </title>
		</head>
		<body>
			<br/>
			<br/>
			<div style="text-align: center; font-size: x-large; font-weight:bold">
			Rules with <xsl:value-of select="$ref"/> Reference in <xsl:value-of select="/cdf:Benchmark/cdf:title" />
			</div>
			<br/>
			<br/>
			<xsl:apply-templates select="cdf:Benchmark"/>
		</body>
		</html>
	</xsl:template>


	<xsl:template match="cdf:Benchmark">
		<style type="text/css">
		table
		{
			border-collapse:collapse;
		}
		table,th, td
		{
			border: 1px solid black;
			vertical-align: top;
			padding: 3px;
		}
		thead
		{
			display: table-header-group;
			font-weight: bold;
		}
		</style>
		<table>
			<thead>
				<td>Reference (<xsl:value-of select="$ref"/>)</td>
				<td>Rule Title</td>
				<td>Description</td>
				<td>Rationale</td>
				<td>Variable Setting</td>
			</thead>

                <xsl:apply-templates select=".//cdf:Rule" />
		</table>
	</xsl:template>


	<xsl:template name="rule-info">
          <xsl:param name="refinfo"/>
		<tr>
			<td> 
			<xsl:value-of select="$refinfo"/>
			</td> 
			<!--<td> <xsl:value-of select="cdf:ident" /></td>-->
			<td> <xsl:value-of select="cdf:title" /></td>
			<td> <xsl:apply-templates select="cdf:description"/> </td>
			<!-- call template to grab text and also child nodes (which should all be xhtml)  -->
			<!-- need to resolve <sub idref=""> here  -->
			<td> <xsl:value-of select="cdf:rationale"/> </td>
			<td> <!-- TODO: print refine-value from profile associated with rule --> </td>
			<!-- select the desired reference via href attribute.  here, NIST. -->
		</tr>
        </xsl:template>


	<xsl:template match="cdf:Rule">
		  <xsl:if test="cdf:reference[@href=$nist800-53uri] and $ref='nist'">
                    <xsl:call-template name="rule-info">
		      <xsl:with-param name="refinfo" select="cdf:reference" />
                    </xsl:call-template>
		  </xsl:if>
		  <xsl:if test="cdf:reference[@href=$dcid63uri] and $ref='dcid'">
                    <xsl:call-template name="rule-info">
		      <xsl:with-param name="refinfo" select="cdf:reference[@href=$dcid63uri]" />
                    </xsl:call-template>
		  </xsl:if>
		  <xsl:if test="cdf:reference[@href=$cnss1253uri] and $ref='cnss'">
                    <xsl:call-template name="rule-info">
		      <xsl:with-param name="refinfo" select="cdf:reference[@href=$cnss1253uri]" />
                    </xsl:call-template>
		  </xsl:if>
	</xsl:template>


	<xsl:template match="cdf:check">
		<xsl:for-each select="cdf:check-export">
			<xsl:variable name="rulevar" select="@value-id" />
				<!--<xsl:value-of select="$rulevar" />:-->
				<xsl:for-each select="/cdf:Benchmark/cdf:Profile[@id=$profile]/cdf:refine-value">
					<xsl:if test="@idref=$rulevar">
						<xsl:value-of select="@selector" />
					</xsl:if>
				</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
<!--
	<xsl:template match="cdf:reference">
		  <xsl:if test="@href=$nist800-53uri and $ref='nist'">
		    <xsl:value-of select="." />
		  </xsl:if>
		  <xsl:if test="@href=$dcid63uri and $ref='dcid'">
		    <xsl:value-of select="." />
		  </xsl:if>
		  <xsl:if test="@href=$cnss1253uri and $ref='cnss'">
		    <xsl:value-of select="." />
		  </xsl:if>
	</xsl:template>
-->
	<xsl:template match="cdf:description">
		<!-- print all the text and children (xhtml elements) of the description -->
		<xsl:copy-of select="./node()" />
	</xsl:template>

</xsl:stylesheet>