class CommentedXML {

	private function new() {
		var libXML:FastXMLList = p.assetLibrary;
		libXML.descendants('child').set(0, FastXML.parse('<empty/>'));
		libXML.descendants('child').set(1, FastXML.parse('<!-- <empty/> -->'));
		libXML.descendants('child').set(2, FastXML.parse('<![CDATA[ <empty/> ]]>'));
		libXML.descendants('child').set(3, FastXML.parse('<root><![CDATA[
			<xml version=\'1.0\' encoding=\'UTF-8\'>
			]]></root>'));
		project.appendChild(libXML);
	}

}