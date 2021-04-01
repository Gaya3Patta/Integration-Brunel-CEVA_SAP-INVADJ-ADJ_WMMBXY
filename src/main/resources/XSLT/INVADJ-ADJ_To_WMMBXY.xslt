<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="functions" exclude-result-prefixes="xs fn xsl" version="2.0">
	<xsl:output omit-xml-declaration="no" indent="yes"/>
	<xsl:param name="idocType"/>
	<xsl:param name="messageType"/>
	<xsl:param name="r3name"/>
	<xsl:param name="recipientPort"/>
	<xsl:param name="recipientPartnerNumber"/>
	<xsl:param name="recipientPartnerType"/>
	<xsl:param name="senderPort"/>
	<xsl:param name="senderPartnerNumber"/>
	<xsl:param name="senderPartnerType"/>
	<xsl:param name="client"/>
	<xsl:variable name="type" select="concat('http://sap.fusesource.org/idoc/', $r3name, '/', $idocType, '///')"/>
	<xsl:template match="Invadj">
		<xsl:variable name="dt" select="InterchangeSection/TransferDTstamp"/>
		<xsl:variable name="intTrnsDate" select="xs:dateTime(concat(substring($dt,1,4),'-',substring($dt,5,2),'-',substring($dt,7,2),'T',substring($dt,9,2),':',substring($dt,11,2),':',substring($dt,13,2)))"/>
		<idoc:Document xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:idoc="http://sap.fusesource.org/idoc" client="{$client}" creationDate="{current-dateTime()}" creationTime="{current-dateTime()}" iDocType="{$idocType}" iDocTypeExtension="" messageType="{$messageType}" recipientPartnerNumber="{$recipientPartnerNumber}" recipientPartnerType="{$recipientPartnerType}" recipientPort="{$recipientPort}" senderPartnerNumber="{$senderPartnerNumber}" senderPartnerType="{$senderPartnerType}" senderPort="{$senderPort}">
			<xsl:namespace name="{$idocType}---">
				<xsl:value-of select="$type"/>
			</xsl:namespace>
			<xsl:variable name="toInv" select="Item/ToSubInventory"/>
			<xsl:variable name="fromInv" select="Item/FromSubInventory"/>
			<xsl:variable name="qtt" select="Item/QuantityChanged"/>
			<xsl:variable name="movementCode">
				<xsl:if test="$toInv = 'DES' and $fromInv = 'AVL'">
					<xsl:value-of select="'551'"/>
				</xsl:if>
				<xsl:if test="$toInv = 'DES' and (('DAM', 'NCD') = $fromInv or ($fromInv = 'RET' and $qtt &lt;0))">
					<xsl:value-of select="'555'"/>
				</xsl:if>
				<xsl:if test="('QAH', 'INS', 'DAM') = $fromInv and $qtt &lt;0">
					<xsl:value-of select="'708'"/>
				</xsl:if>
				<xsl:if test="('QAH', 'INS', 'DAM', 'NCD') = $toInv and $qtt &gt;=0">
					<xsl:value-of select="'707'"/>
				</xsl:if>
				<xsl:if test="$fromInv = 'AVL'">
					<xsl:value-of select="'702'"/>
				</xsl:if>
				<xsl:if test="$toInv = 'AVL'">
					<xsl:value-of select="'701'"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="grund">
				<xsl:value-of select="if($fromInv = 'RET' and $qtt &lt;0)
											then '0004'
											else if($fromInv = 'DAM' and $toInv = 'DES')
												then '0003'
												else ()"/>
			</xsl:variable>
			<rootSegment xsi:type="{$idocType}---:ROOT" document="/">
				<segmentChildren parent="//@rootSegment">
					<E1MBXYH parent="//@rootSegment" document="/" BLDAT="{$intTrnsDate}" BUDAT="{$intTrnsDate}" XBLNR="{InterchangeSection/InterChangeID}" TCODE="{if(substring($movementCode, 1, 1) = '7') then 'MI10' else if(substring($movementCode, 1, 1) = '5') then 'MB1A' else (error(QName('http://www.w3.org/2005/xqt-errors', 'err:MissingData'),'Data in FromSubInventory/ToSubInventory does not match expected values.'))}">
						<xsl:if test="Item/Reference/Value !=''">
							<xsl:attribute name="BKTXT">
								<xsl:value-of select="Item/Reference/Value"/>
							</xsl:attribute>
						</xsl:if>
						<segmentChildren parent="//@rootSegment/@segmentChildren/@E1MBXYH.0">
							<E1MBXYI parent="//@rootSegment/@segmentChildren/@E1MBXYH.0" document="/" MATNR="{Item/ProductId}" ERFMG="{Item/QuantityChanged}" ERFME="{Item/UOM}" BWART="{$movementCode}">
								<xsl:if test="$grund != ''">
									<xsl:attribute name="GRUND" select="$grund"/>
								</xsl:if>
								<xsl:attribute name="WERKS">
									<xsl:if test="Item/LocationID !='' and Item/LocationID ='IN-CHE-01'">7414</xsl:if>
									<xsl:if test="Item/LocationID !='' and Item/LocationID ='IN-SON-01'">7430</xsl:if>
								</xsl:attribute>
								<xsl:attribute name="LGORT">
									<xsl:if test="Item/LocationID !='' and Item/LocationID ='IN-CHE-01'">1400</xsl:if>
									<xsl:if test="Item/LocationID !='' and Item/LocationID ='IN-SON-01'">3000</xsl:if>
								</xsl:attribute>
							</E1MBXYI>
						</segmentChildren>
					</E1MBXYH>
				</segmentChildren>
			</rootSegment>
		</idoc:Document>
	</xsl:template>
</xsl:stylesheet>