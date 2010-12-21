import org.antlr.runtime.*;

public class Main
{
	public static void main(String[] args) throws Exception
	{
		CharStream input = new ANTLRFileStream(args[0]);
		plp2Lexer lex = new plp2Lexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lex);
		plp2Parser parser = new plp2Parser(tokens);
		parser.prog();
	}
}