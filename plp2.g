grammar plp2;

@header
{
	import java.lang.String;
}

@member
{
	private TablaSimbolos ts;
	boolean mainFlag;
}

s 
returns [String trad] 
: c*;

c 
returns [String trad] 
: CLASS ID LLAVEI d LLAVED;

d 
: (v | m)*;

v [boolean atributo]
: DOUBLE ID PYC | INT ID PYC;

m 
: VOID mid PARI PARD LLAVEI
{
	ts = new TablaSimbolos(ts);
	bufferesLocales.clear();
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
		// Lanzar error 5
	}
	
	$trad = $ID.text;
} 
| MAIN 
{ 
	if (ts.insertar("main",Simbolo.Tipo.METODO) == null)
	{
		// Lanzar error 5
	}
	
	mainFlag = true;
	
	$trad = "main" ;
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