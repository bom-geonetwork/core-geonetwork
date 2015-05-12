<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
						xmlns:gml30="http://www.opengis.net/gml"
						xmlns:gml="http://www.opengis.net/gml/3.2"
						xmlns:srv="http://www.isotc211.org/2005/srv"
						xmlns:gmx="http://www.isotc211.org/2005/gmx"
						xmlns:gco="http://www.isotc211.org/2005/gco"
						xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
						xmlns:xlink="http://www.w3.org/1999/xlink"
						xmlns:gmi="http://www.isotc211.org/2005/gmi"
						xmlns:gmd="http://www.isotc211.org/2005/gmd"
						xmlns:geonet="http://www.fao.org/geonet"
						exclude-result-prefixes="gmi geonet">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

	<!-- ================================================================= -->
	
	<xsl:template match="/">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	
	<!-- ================================================================= -->
	
	<xsl:template match="gmd:MD_Metadata" priority="400">
		<xsl:element name="gmi:MI_Metadata">
			<xsl:namespace name="gmi" select="'http://www.isotc211.org/2005/gmi'"/>
			<xsl:namespace name="gmd" select="'http://www.isotc211.org/2005/gmd'"/>
			<xsl:namespace name="gco" select="'http://www.isotc211.org/2005/gco'"/>
			<xsl:namespace name="gmx" select="'http://www.isotc211.org/2005/gmx'"/>
			<xsl:namespace name="srv" select="'http://www.isotc211.org/2005/srv'"/>
			<xsl:namespace name="gml" select="'http://www.opengis.net/gml/3.2'"/>
			<xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
			<xsl:copy-of select="@*[name()!='xsi:schemaLocation' and name()!='gco:isoType']"/>
			<xsl:attribute name="xsi:schemaLocation">http://www.isotc211.org/2005/gmi http://standards.iso.org/19115/-2/gmi/1.0/gmi.xsd http://www.isotc211.org/2005/gmd http://standards.iso.org/19115/-2/gmd/1.0/gmd.xsd http://www.opengis.net/gml/3.2 http://www.opengis.net/gml/3.2/gml.xsd</xsl:attribute>
			<xsl:apply-templates select="child::*"/>
		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="gmd:metadataStandardName">
		<xsl:copy copy-namespaces="no">
			<gco:CharacterString>ISO 19115-2:2008/19139</gco:CharacterString>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	
	<xsl:template match="gmd:metadataStandardVersion">
		<xsl:copy copy-namespaces="no">
			<gco:CharacterString>1.0</gco:CharacterString>
		</xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="gml30:*">
		<xsl:element name="{local-name(.)}" namespace="http://www.opengis.net/gml/3.2">
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template match="@gml30:*">
		<xsl:attribute name="gml:{local-name()}">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>
	
	<!-- ================================================================= -->

	<xsl:template match="@*|node()">
		 <xsl:copy copy-namespaces="no">
			  <xsl:apply-templates select="@*|node()"/>
		 </xsl:copy>
	</xsl:template>

	<!-- ================================================================= -->
	
</xsl:stylesheet>
