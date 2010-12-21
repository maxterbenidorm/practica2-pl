
/**
 *
 * @author david
 */
public class Simbolo
{
    public enum Tipo
    {
	CLASE,
	VARIABLE,
	METODO
    }

    private String nombre;
    private Tipo simbolo;
    private boolean referenciado;

    public Simbolo(String nombre, Tipo simbolo)
    {
	this.nombre = nombre;
	this.simbolo = simbolo;
	this.referenciado = false;
    }

    public String getNombre()
    {
	return nombre;
    }

    public Tipo getTipo()
    {
	return simbolo;
    }

    public boolean isReferenciado()
    {
	return referenciado;
    }

    public void setReferenciado(boolean referenciado)
    {
	this.referenciado = referenciado;
    }
}
