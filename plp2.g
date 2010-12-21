grammar plp2;

@header
{
	import java.lang.String;
	import java.util.ArrayList;
	import java.util.HashMap;
}

@members
{
	private TablaSimbolos ts = new TablaSimbolos();
	private boolean mainFlag = false;
    
    private ArrayList<String> bufferAtributos = new ArrayList<String>();
    private HashMap<String, Simbolo> atributosSimbolos = new HashMap<String,Simbolo>();
    private ArrayList<String> bufferMetodos = new ArrayList<String>();
    private HashMap<String, Simbolo> metodosSimbolos = new HashMap<String,Simbolo>();
    private ArrayList<String> bufferLocales = new ArrayList<String>();
    private HashMap<String, Simbolo> localesSimbolos = new HashMap<String,Simbolo>();

	private String espacios()
	{
		String espacios = "";

		for (int i = 0; i < ts.getNivel(); i++)
		{
		    espacios += "    ";
		}

		return espacios;
	}
}



prog 
: s EOF
{
	if (mainFlag)
	{
		System.out.println($s.trad);
	}
	else
	{
		// Lanzar error 9
	}
};



s 
returns [String trad] 
: (c { $trad = $trad + $c.trad; })*;



c 
returns [String trad] 
: CLASS ID
{
	if (ts.insertar($ID.text, Simbolo.Tipo.CLASE) == null)
    {
		// Lanzar error 5
    }
} 
LLAVEI
{
	ts = new TablaSimbolos(ts);
    
    bufferAtributos.clear();
    atributosSimbolos.clear();
    bufferMetodos.clear();
    metodosSimbolos.clear();
} 
d LLAVED
{
	ts = ts.restaurar();
    String cStr = espacios() + "class " + $ID.text + " {\n";

    for (String s : bufferAtributos)
    {
		if (atributosSimbolos.get(s).isReferenciado())
		{
		    cStr += s;
		}
    }

    for (String s : bufferMetodos)
    {
		if (metodosSimbolos.get(s).isReferenciado() ||
		    metodosSimbolos.get(s).getNombre().equals("main"))
		{
		    cStr += s;
		}
    }

    $trad = cStr + espacios() + "}\n";
};



d 
: (v[true] | m)*;



v [boolean atributo]
: DOUBLE ID 
{
	Simbolo s = ts.insertar($ID.text, Simbolo.Tipo.VARIABLE);
	
	if (s == null)
	{
		// Lanzar error 5
	}
}
PYC
{
	String vStr = espacios() + "double " + $ID.text + ";\n";
	
	if (atributo)
	{
		bufferAtributos.add(vStr);
		atributosSimbolos.put(vStr,s);
	}
	else
	{
		bufferLocales.add(vStr);
		localesSimbolos.put(vStr,s);
	}
} 
| INT ID
{
	Simbolo s = ts.insertar($ID.text, Simbolo.Tipo.VARIABLE);
	
	if (s == null)
	{
		// Lanzar error 5
	}
}
PYC
{
	String vStr = espacios() + "int " + $ID.text + ";\n";
	
	if (atributo)
	{
		bufferAtributos.add(vStr);
		atributosSimbolos.put(vStr,s);
	}
	else
	{
		bufferLocales.add(vStr);
		localesSimbolos.put(vStr,s);
	}	
};



m 
: VOID mid PARI PARD LLAVEI
{
	ts = new TablaSimbolos(ts);
	bufferLocales.clear();
	localesSimbolos.clear();
} 
decl cuerpo LLAVED
{
	ts = ts.restaurar();
	String mStr = espacios() + "void " + $mid.trad + " () {\n";
	
	for (String s : bufferLocales)
	{
		if (localesSimbolos.get(s).isReferenciado())
		{
			mStr += s;
		}
	}
	
	mStr += $cuerpo.trad + espacios() + "}\n";
	bufferMetodos.add(mStr);
	metodosSimbolos.put(mStr,ts.buscar($mid.trad));	
};



mid
returns [String trad] 
: ID 
{
	if (ts.insertar($ID.text,Simbolo.Tipo.METODO) == null)
	{
		// Lanzar error 5 y stop
	}
	
	$trad = $ID.text;
} 
| MAIN 
{ 
	if (ts.insertar("main",Simbolo.Tipo.METODO) == null)
	{
		// Lanzar error 5 y stop
	}
	
	mainFlag = true;
	
	$trad = "main";
};



decl 
: (v[false])*;



cuerpo
returns [String trad] 
: (instr { $trad = $trad + $instr.trad; })*;



instr 
returns [String trad] 
: ID 
{
	Simbolo s = ts.buscar($ID.text);
	
	if (s == null)
	{
		// Lanzar error 6
	}
	
	s.setReferenciado(true);	
} 
asig[$ID.text,s.getTipo()] PYC { $trad = espacios() + $ID.text + " " + $asig.trad + ";\n"; };



asig [String id, Simbolo.Tipo tipo] 
returns [String trad] 
: 
{
	if ($tipo != Simbolo.Tipo.VARIABLE)
	{
		// Lanzar error 7
	}
} 
ASIG factor { $trad = "= " + $factor.trad; }
|
{ 
	if ($tipo != Simbolo.Tipo.METODO)
	{
		// Lanzar error 8
	} 
} 
PARI PARD { $trad = "()"; };



factor 
returns [String trad] 
: REAL 		{ $trad = $REAL.text; } 
| ENTERO 	{ $trad = $ENTERO.text; } 
| ID 
{
	Simbolo s = ts.buscar($ID.text);
	
	if (s == null)
	{
		// Lanzar error 6
	}
	else if (s.getTipo() != Simbolo.Tipo.VARIABLE)
	{
		// Lanzar error 7
	}
	
	s.setReferenciado(true);	
	$trad = $ID.text;
};



PARI		: '(';
PARD		: ')';
PYC			: ';';
ASIG		: '=';
CLASS		: 'class';
DOUBLE		: 'double';
INT			: 'int';
MAIN		: 'main';
VOID		: 'void';
LLAVEI		: '{';
LLAVED		: '}';
ENTERO		: ('0'..'9')+;
ID			: ('a'..'z'|'A'..'Z') ('a'..'z'|'A'..'Z'|'0'..'9')*;
REAL		: ('0'..'9')+ '.' ('0'..'9')+;
COMENTARIO	: '/*' .* '*/' { skip(); }; 
SEPARADOR	: (' '|'\t'|'\r'|'\n')+ { skip(); };