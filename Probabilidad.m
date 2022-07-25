
function [Prob] = Probabilidad( Matrix_Casos, Columna, valor_col )
%Calcula la probabilidad de tener  el valor_col en la columna indicada
%En este caso Matrix_Casos será Train
%Calcular num de registros de Matrix_casos
%Probabilidad = Num eventos / N
%Prob = Num de coincidencias del valor_col en Columna / Total de registros en Matrix_Casos

num = size(Matrix_Casos, 1);
Mapa = Matrix_Casos(:, Columna) == valor_col;
num_criterio = sum(Mapa);
Prob = num_criterio/num;


end