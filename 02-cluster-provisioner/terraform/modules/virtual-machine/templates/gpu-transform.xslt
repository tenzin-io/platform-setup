<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/domain/devices/disk[@device='cdrom']/target/@bus">
    <xsl:attribute name="bus">
      <xsl:value-of select="'sata'"/>
    </xsl:attribute>
  </xsl:template>

  <!-- Match the node where you want to insert new content -->
  <xsl:template match="/domain/devices">
    <xsl:copy>
      <!-- Copy all existing content of the parent node -->
      <xsl:apply-templates select="@*|node()"/>

      <!-- Add new complex nested content -->
      <hostdev mode='subsystem' type='pci' managed='yes'>
        <driver name='vfio'/>
        <source>
          <address domain='0x0000' bus='0x${gpu_pci_bus}' slot='0x00' function='0x0'/>
        </source>
        <alias name='hostdev0'/>
        <address type='pci' domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
      </hostdev>
      <hostdev mode='subsystem' type='pci' managed='yes'>
        <driver name='vfio'/>
        <source>
          <address domain='0x0000' bus='0x${gpu_pci_bus}' slot='0x00' function='0x1'/>
        </source>
        <alias name='hostdev1'/>
        <address type='pci' domain='0x0000' bus='0x06' slot='0x00' function='0x0'/>
      </hostdev>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>