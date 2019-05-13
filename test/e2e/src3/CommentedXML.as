package {

public class CommentedXML {

	function CommentedXML():void
	{
		var libXML:XMLList = p.assetLibrary;
		libXML.child[0] = new XML(<empty/>);
		libXML.child[1] = new XML(<!-- <empty/> -->);
		libXML.child[2] = new XML(<![CDATA[ <empty/> ]]>);
		libXML.child[3] = new XML(<root><![CDATA[
			<xml version='1.0' encoding='UTF-8'>
			]]></root>);
		project.appendChild(libXML);
	}
	
}

}