clc; clear all;
%Lecture d'image et la convertir en niveau gris
Image = imread('img\img.jpeg');
Image = rgb2gray(Image);
%Initialisation :
%probabilit�s de croisement et mutation
Crossover_Prob = 0.5;
Mutation_Prob = 0.5;
mutation_amp = rand();
if ((Mutation_Prob + Crossover_Prob)~=1) 
    error('La somme des probabilit�s doit �tre �gale � 1!');
end
%nombre des it�rations et la taille de fen�tre
Nbr_iteration = 20;
windowArea = 3;
[x,y] = size(Image);
x = x-(2*fix(windowArea/2));
y = y-(2*fix(windowArea/2));
population = repmat(Unite(1,windowArea),[x,y]);
newGeneration = repmat(Unite(1,windowArea),[x,y]);
%Initialisation de la population
disp('Algorithme g�n�tique : Relaxation s�lectionniste');
Label =1;
disp('Initialisation de population en cours...');
for i=1:x
    for j=1:y
        population(i,j)=  Unite(Label,windowArea);
        Label = Label +1;
    end;
end;
%D�clencher le cycle d'it�ration
for z=1:Nbr_iteration
%Fitness
fprintf('Generation %d \n',z);
disp('Evaluation de population en cours...');
for i=1:x
    for j=1:y
        population(i,j).fitness(Image(i:(i+windowArea-1),j:(j+windowArea-1)),windowArea);
    end;
end;
%Tournoi Local
disp('Selection...');
for i=1:x
    for j=1:y
        [k l m n]=Intervalle(i,j,x,y);
        newGeneration(i,j) = SelectionLocal(population(i,j),population(k:l,m:n));
    end;
end
population = newGeneration;
%Elimination des unit�s externes
%� verifier
%disp('Elimination des unit�s externes en cours...');
%for i=1:x
%    for j=1:y
%       [k l m n]=Intervalle(i,j,x,y);
%        newGeneration(i,j) = Elimination(population(i,j),population(k:l,m:n),population);
 %   end;
%end
%population = newGeneration;
%Crossover
disp('Croisement en cours...');
for i=1:x
    for j=1:y
        [k l m n]=Intervalle(i,j,x,y);
        if ~(EdgeUnit(population(i,j),population(k:l,m:n)))
            newGeneration(i,j) = Crossover(population(i,j),Crossover_Prob,population(k:l,m:n),windowArea);
        else newGeneration(i,j) = population(i,j);
        end
    end;
end
population = newGeneration;
%Mutation
disp('Mutation en cours...');
for i=1:x
    for j=1:y
        [k l m n]=Intervalle(i,j,x,y);
        if ~(EdgeUnit(population(i,j),population(k:l,m:n)))
            newGeneration(i,j) = Mutation(population(i,j),Mutation_Prob,mutation_amp,windowArea);
        else newGeneration(i,j) = population(i,j);
        end   
    end;
end
population = newGeneration;
disp('Enregistrement du photo dans le dossier res');
m = ones(x,y);
    for i=1:x 
      for j=1:y 
           m(i,j) = moy(population(i,j).Chromosome); 
      end; 
    end
     img = mat2gray(m, [0 255]);
     imwrite(img,sprintf('res/generation %d.jpg',z));
end

disp('finis');