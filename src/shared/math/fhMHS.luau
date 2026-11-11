--[[
    Funcao horaria do Movimento Harmonico Simples (MHS)

    @param A - amplitude
    @param w - frequencia angular
    @param t - tempo
    @param p0 - angulo inicial (geralmente 0)

    @return number
]] 
return function(A: number, w: number, t: number, p0: number): number
    return A * math.sin(w * t + p0)
end