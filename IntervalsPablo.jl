module Intervals

import Base.==, Base.contains, Base.^

export Interval, +,-,*,/, ==,^, midpoint, contains

#Ahora quiero implementar redondeo. lo más lógico es redondear el primer número para abajo y el segundo para arriba
type Interval
    
    a::Float64
    b::Float64
    
    Interval(a,b) = a > b ? new(b,a) : new(a,b)

end
    

#Estas funciones sirven para hacer aritmética con redondeo dirigido


function UpSum(x,y)
    with_rounding(Float64,RoundUp) do
        x+y
    end
end

function DownSum(x,y)
    with_rounding(Float64,RoundDown) do
        x+y
    end
end

function UpSubs(x,y)
    with_rounding(Float64,RoundUp) do
        x-y
    end
end

function DownSubs(x,y)
    with_rounding(Float64,RoundDown) do
        x-y
    end
end

function UpProd(x,y)
    with_rounding(Float64,RoundUp) do
        x*y
    end
end

function DownProd(x,y)
    with_rounding(Float64,RoundDown) do
        x*y
    end
end

function UpDiv(x,y)
    with_rounding(Float64,RoundUp) do
        x/y
    end
end

function DownDiv(x,y)
    with_rounding(Float64,RoundDown) do
        x/y
    end
end

function UpExp(x,y)
    with_rounding(Float64,RoundUp) do
        x^y
    end
end

function DownExp(x,y)
    with_rounding(Float64,RoundDown) do
        x^y
    end
end

#Revisa si un número dado está en un intervalo

function contains(x::Interval, n::Real)
	
	n>=x.a && n<=x.b
end

#Aritmética de intervalos

function +(x::Interval, y::Interval)
    
    z=Interval(DownSum(x.a,y.a),UpSum(x.b,y.b))
    
end


function -(x::Interval, y::Interval)
    
    z=Interval(DownSubs(x.a,y.a),UpSubs(x.b,y.b))
    
end

function +(x::Interval, y::Float64)
    
    z=Interval(DownSum(x.a,y),UpSum(x.b,y))
    
end


function -(x::Interval, y::Float64)
    
    z=Interval(DownSubs(x.a,y),UpSubs(x.b,y))
    
end

#para la multiplicación y la división es un poco más complejo, así que tomo el intervalo más amplio posible, es decir, el m'inimo de las multiplicaciones 
#posibles como a y el máximo como b, y así mismo para la división


function *(x::Interval, y::Interval)
    
    z=Interval(min(DownProd(x.a,y.a),DownProd(x.a,y.b),DownProd(x.b,y.a),DownProd(x.b,y.b)),max(UpProd(x.a,y.a),UpProd(x.a,y.b),UpProd(x.b,y.a),UpProd(x.b,y.b)))
    
end

function /(x::Interval, y::Interval)
    
    if contains(y,0.0)
	error("No puedo dividir por un intervalo que contiene el 0")
    end	
    
    z=Interval(min(DownDiv(x.a,y.a),DownDiv(x.a,y.b),DownDiv(x.b,y.a),DownDiv(x.b,y.b)),max(UpDiv(x.a,y.a),UpDiv(x.a,y.b),UpDiv(x.b,y.a),UpDiv(x.b,y.b)))
    
end

function *( y::Float64,x::Interval)
    
    z=Interval(DownProd(x.a,y),UpProd(x.b,y))
    
end

function /(x::Interval, y::Interval)
    
    if contains(y,0.0)
	error("No puedo dividir por un intervalo que contiene el 0")
    end	
    
    z=Interval(min(DownDiv(x.a,y.a),DownDiv(x.a,y.b),DownDiv(x.b,y.a),DownDiv(x.b,y.b)),max(UpDiv(x.a,y.a),UpDiv(x.a,y.b),UpDiv(x.b,y.a),UpDiv(x.b,y.b)))
    
end

#potencia de un intervalo

function ^(x::Interval,n::Int64)

    if isodd(n) 
        return(Interval(x.a^n,x.b^n))
    end

    if iseven(n)
        if x.a>=0
            Interval((x.a)^n,(x.b)^n)
        else
            Interval(0,x.b^n)
        end
    end
end

		
			
#Punto medio de un intervalo

function midpoint(x::Interval)
	
	(x.a+x.b)/2
end

#Comparación de intervalos

function ==(x::Interval, y::Interval)
	
	(x.a == y.a) && (x.b == y.b)

end





end
