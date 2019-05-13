package as3hx.parsers;

import haxe.io.Input;
import as3hx.Tokenizer;
import as3hx.Error;

class XMLReader {

    public static function read(tokenizer:Tokenizer, lvl:Int = 0):String {
        Debug.dbgln("readXML()", tokenizer.line);
        var buf = new StringBuf();
        var input = tokenizer.input;
        if (lvl == 0)
            buf.addChar("<".code);
        buf.addChar(tokenizer.char);
        var isCDATA = tokenizer.char == "!".code;
        tokenizer.char = 0;
        if (isCDATA) {
            var end1 = input.readByte();
            var end2 = input.readByte();
            buf.addChar(end1);
            buf.addChar(end2);
            if (end1 == "[".code) {
                if (end2 != "C".code)
                    throw EInvalidChar(end2);
                end1 = "]".code;
                end2 = "]".code;
            } else if (end1 == "-".code) {
                if (end2 != "-".code)
                    throw EInvalidChar(end2);
            } else {
                throw EInvalidChar(end1);
            }
            goto(tokenizer, buf, [end1, end2, ">".code]);
            if (lvl == 0) tokenizer.char = input.readByte();
            return buf.toString();
        }
        try {
            var prev:Int = goto(tokenizer, buf, [">".code]);
            if ( prev != "/".code ) {
                while (true) {
                    goto(tokenizer, buf, ["<".code]);
                    tokenizer.char = input.readByte();
                    if (tokenizer.char == "/".code) {
                        buf.addChar(tokenizer.char);
                        goto(tokenizer, buf, [">".code]);
                        break;
                    } else {
                        var s = read(tokenizer, lvl + 1);
                        buf.add(s);
                    }
                }
            }
            if (lvl == 0) tokenizer.char = input.readByte();
            return buf.toString();
        } catch( e : haxe.io.Eof ) {
            throw EUnterminatedXML;
        }
    }

    private static function goto(tokenizer:Tokenizer, buf:StringBuf, chars:Array<Int>):Int {
        var input:Input = tokenizer.input;
        var prevs:Array<Int> = [];
        while (true) {
            var c:Int = input.readByte();
            buf.addChar(c);
            prevs.push(c);
            if (c == "\n".code) tokenizer.line++;
            if (prevs.length >= chars.length) {
                var prev:Int = 0;
                if (prevs.length > chars.length) {
                    prev = prevs[prevs.length - 2];
                    prevs.shift();
                }
                var ok:Bool = true;
                for (i in 0...chars.length) {
                    if (prevs[i] != chars[i]) {
                        ok = false;
                        break;
                    }
                }
                if (ok) {
                    tokenizer.char = c;
                    return prev;
                }
            }
        }
        return 0;
    }

}
