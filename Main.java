
/**
 *
 * @author david
 */
public class Main
{
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args)
    {
	String filename = args[0];

	/*
	AnalizadorLexico al = new AnalizadorLexico(filename);
	Token t = al.siguienteToken();

	while (t != null && t.getTipo() != Token.Tipo.EOF)
	{
	    System.out.println(t);

	    t = al.siguienteToken();
	}
	*/

	AnalizadorSintactico as = new AnalizadorSintactico();

	as.analisisDescendenteRecursivo(filename);
    }

}
