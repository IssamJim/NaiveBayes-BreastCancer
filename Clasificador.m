                                        %N A I V E  B A Y E S
                                        
                                          %T R A I N I N G

%Paso 1
Prob_M = Probabilidad( Train, 11, 4 ); %Probabilidad de  que los casos sean malignos
Prob_B = 1-Prob_M;                     %Probabilidad de que los casos sean benignos

%Paso 2
Map_Maligno = Train(:,11)==4;     %Filtra los casos que sean igual a 4 osea malignos
Malignos=Train((Map_Maligno), :); %Crea la matriz con puros casos malignos

Map_Benigno = Train(:,11)==2;
Benignos=Train((Map_Benigno), :);

Num_malignos=size(Malignos, 1); %Numero de casos malignos 
Num_Benignos=size(Benignos, 1); %Numero de casos benignos

A=unique(Train(:,2:10)); %Saca los valores unicos de la columna 2 a la 10 de la matriz de train
SA=size(A,1);
col=(2:10);
ind=(1:10)';

%Matriz de Malignos
Mtx=Malignos;
for c=1:SA
    A(c,col)= sum(Mtx(:, col) == A(c,1));
end 

CMal=A(:,2:10)+1;
ConMal=[ind,CMal];
SMal=sum(ConMal);
FNM=SMal(2);
Norm_Mal=ConMal(:,2:10)/FNM;
Norm_Mal=[ind,Norm_Mal];

%Matriz de Benignos
Mtz=Benignos;
AB = A;

for c=1:SA
    AB(c,col)= sum(Mtz(:, col) == A(c,1));
end 

CBen=AB(:,2:10)+1;
ConBen=[ind,CBen];
SBen=sum(ConBen);
FNB=SBen(2);
Norm_Ben=ConBen(:,2:10)/FNB;
Norm_Ben=[ind,Norm_Ben];
                            
                                               %T E S T I N G
                             
SAT=size(Test); %Obtenemos las dimenciones de la matriz Test
Conteo=zeros(SAT(1),3); %Creamos matriz de conteos

for f=1:SAT(1)    
x=Test(f,2:11); %Iteramos caso por caso de la matriz Test
k=Prob_B; %Probabilidad a priori de los casos Benignos

    for c=1:9
        k=k*Norm_Ben(x(c),c+1); %Iteramos por cada feature de cada registro de la matriz Test
    end                         %y multiplicamos por su respectiva probabilidad
    Conteo(f)=k; %Agregamos la probabilidad final de que sea benigno para cada caso en una matriz de conteo
end

for f=1:SAT(1)    
x=Test(f,2:11);
k=Prob_M;

    for c=1:9
        k=k*Norm_Mal(x(c),c+1); %Ahora sacamos las probabilidades de que el caso sea maligno
    end
    Conteo(f,2)=k; %Agregamos el caso en la siguiente columna de la matriz de conteo para coomparar los resultados
end

for s=1:SAT(1)
   if Conteo(s)>Conteo(s,2);  %Dependiendo de la mayor probabilidad agregamos 2 si es benigno o 4 si es maligno
       Conteo(s,3)=2;
   else
       Conteo(s,3)=4;
   end
end

Coomp=Test(:,11)==Conteo(:,3); %Coomparamos los resultados obtenidos en la matriz de conteo con los datos reales de la matriz Test
Porcentaje=sum(Coomp)/SAT(1);%Sacamos el porcentaje de aciertos obtenidos para toda la matriz Test

                                            %Test Malignos
                                            
                %Repetimos el proceso ahora separando los casos malignos de la matriz Test
                
TestMalignos1 = Test(:,11)==4;  
TestMalignos=Test((TestMalignos1), :);  %Tomamos todos los registros malignos de la matriz Test

STM=size(TestMalignos);   
ConteoMaligno=zeros(STM(1),3); 

for f=1:STM(1)    
x=TestMalignos(f,2:11);
k=Prob_M;

    for c=1:9
        k=k*Norm_Mal(x(c),c+1);        
    end
    ConteoMaligno(f,2)=k;
end

for f=1:STM(1)    
x=TestMalignos(f,2:11);
k=Prob_B;

    for c=1:9
        k=k*Norm_Ben(x(c),c+1);        
    end
    ConteoMaligno(f)=k;
end

for s=1:STM(1)
   if ConteoMaligno(s)>ConteoMaligno(s,2);
       ConteoMaligno(s,3)=2;
   else
       ConteoMaligno(s,3)=4;
   end
end

CoompM=TestMalignos(:,11) == ConteoMaligno(:,3);
PorcentajeM=sum(CoompM)/STM(1);

                                            %Test Benignos
                                             
               %Repetimos el proceso ahora separando los casos Benignos de la matriz Test
               
TestBenignos1 = Test(:,11)==2;
TestBenignos=Test((TestBenignos1), :); %Tomamos todos los registros benignos de la matriz Test.

STB=size(TestBenignos);
ConteoBenigno=zeros(STB(1),3);

for f=1:STB(1)    
x=TestBenignos(f,2:11);
k=Prob_M;

    for c=1:9
        k=k*Norm_Mal(x(c),c+1);        
    end
    ConteoBenigno(f,2)=k;
end

for f=1:STB(1)    
x=TestBenignos(f,2:11);
k=Prob_B;

    for c=1:9
        k=k*Norm_Ben(x(c),c+1);        
    end
    ConteoBenigno(f)=k;
end

for s=1:STB(1)
   if ConteoBenigno(s)>ConteoBenigno(s,2);
       ConteoBenigno(s,3)=2;
   else
       ConteoBenigno(s,3)=4;
   end
end

CoompB=TestBenignos(:,11) == ConteoBenigno(:,3);
PorcentajeB=sum(CoompB)/STB(1);

                                            %M e t r i c s 
                                            
TruePositive(1)=sum(CoompB);
FalseNegative=STB(1)-TruePositive;
TrueNegative(1)=sum(CoompM);
FalsePositive=STM(1)-TrueNegative;

                                            %P r e c i s i o n
Precision = TruePositive /(TruePositive + FalsePositive);

                                            %R e c a l l
Recall  = TruePositive /(TruePositive + FalseNegative);

                                            %F-Score
FScore= 2 * Precision * Recall / (Precision + Recall);                                        