
import java.util.HashMap;

/**
 *
 * @author david
 */
public class TablaSimbolos
{
    private TablaSimbolos padre;
    private HashMap<String, Simbolo> simbolos;
    private int nivel;

    public TablaSimbolos()
    {
	this.padre = null;
	this.simbolos = new HashMap<String, Simbolo>();
	this.nivel = 0;
    }

    public TablaSimbolos(TablaSimbolos padre)
    {
	this.padre = padre;
	this.simbolos = new HashMap<String, Simbolo>();
	this.nivel = padre.nivel + 1;
    }

    public int getNivel()
    {
	return nivel;
    }

    private boolean existe(String nombre)
    {
	return simbolos.containsKey(nombre);
    }

    public Simbolo buscar(String nombre)
    {
	if (simbolos.containsKey(nombre))
	{
	    return simbolos.get(nombre);
	}
	else if (padre != null)
	{
	    return padre.buscar(nombre);
	}
	else
	{
	    return null;
	}
    }

    public Simbolo insertar(String nombre, Simbolo.Tipo simbolo)
    {
	if (!existe(nombre))
	{
	    Simbolo s = new Simbolo(nombre, simbolo);
	    simbolos.put(nombre, s);
	    return s;
	}
	else
	{
	    return null;
	}
    }

    public TablaSimbolos restaurar()
    {
	return padre;
    }
}
