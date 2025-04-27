import numpy as np
import random

class CustomBenEvolutionaryAlgorithm:
    def __init__(self, fitness_function, bounds, dimension, population_size=100,
                 crossover_prob=0.7, mutation_prob=0.3, tournament_size=5, elitism=True, max_evals=10000, max_age=3):
        self.fitness_function = fitness_function
        self.bounds = bounds
        self.dimension = dimension
        self.population_size = population_size
        self.crossover_prob = crossover_prob
        self.mutation_prob = mutation_prob
        self.tournament_size = tournament_size
        self.elitism = elitism
        self.max_evals = max_evals
        self.max_age = max_age  # Edad máxima para los individuos

        self.population = self.initialize_population()
        self.evaluations = len(self.population)
        self.history = []
        self.fitness = np.array([self.evaluate(ind) for ind in self.population])
        self.age = [0] * self.population_size  # Edad inicial de los individuos

    def initialize_population(self):
        return [np.random.uniform(low=self.bounds[0], high=self.bounds[1], size=self.dimension)
                for _ in range(self.population_size)]

    def evaluate(self, individual):
        value = self.fitness_function(individual)
        self.evaluations += 1

        if not hasattr(self, 'best_so_far') or value < self.best_so_far:
            self.best_so_far = value

        self.history.append((self.evaluations, individual.copy(), self.best_so_far))
        return value

    def select_parents(self):
        parents = []
        for _ in range(self.population_size):
            contenders = random.sample(list(zip(self.population, self.fitness)), self.tournament_size)
            winner = min(contenders, key=lambda x: x[1])
            parents.append(winner[0])
        return parents
    
    def generate_offspring(self, parents):
        offspring = []

        for i in range(0, self.population_size, 2):
            p1 = parents[i]
            p2 = parents[(i+1) % self.population_size]
            child1 = self.crossover(p1, p2)
            child2 = self.crossover(p2, p1)
            child1 = self.mutate(child1)
            child2 = self.mutate(child2)
            offspring.append(child1)
            offspring.append(child2)
        
        return offspring
    
    def evaluate_different_offspring(self, offspring):
        offspring_fitness = []

        for child in offspring:
            found = False
            for i, p in enumerate(self.population):
                if np.array_equal(child, p):
                    offspring_fitness.append(self.fitness[i])
                    found = True
                    break
            if not found:
                offspring_fitness.append(self.evaluate(child))
        
        return offspring_fitness

    def crossover(self, parent1, parent2):
        child = parent1.copy()
        if np.random.rand() < self.crossover_prob:
            alpha = np.random.rand()
            index = np.random.randint(0, self.dimension)  # Seleccionar posición aleatoria
            child[index] = alpha * parent1[index] + (1 - alpha) * parent2[index]
        return child

    def mutate(self, individual):
        if np.random.rand() < self.mutation_prob:
            index = np.random.randint(0, self.dimension)
            mutation_strength = (self.bounds[1] - self.bounds[0]) * 0.1
            individual[index] += np.random.normal(0, mutation_strength)
            individual[index] = np.clip(individual[index], self.bounds[0], self.bounds[1])
        return individual

    def age_based_replacement(self, offspring, offspring_fitness):
        # Combina la población actual con la descendencia y sus edades
        combined = list(zip(self.population, self.fitness, self.age)) + list(zip(offspring, offspring_fitness, [0] * len(offspring)))
        
        # Ordena por fitness y luego por edad (priorizando a los más jóvenes)
        combined.sort(key=lambda x: (x[1], x[2]))  # Primero por fitness, luego por edad
        
        # Selecciona los mejores individuos para la nueva población
        new_population = [ind for ind, fit, age in combined[:self.population_size]]
        new_fitness = [fit for ind, fit, age in combined[:self.population_size]]
        
        # Incrementa la edad de los sobrevivientes
        new_age = [age + 1 for ind, fit, age in combined[:self.population_size]]
        
        # Actualiza la población, fitness y edad
        self.population = new_population
        self.fitness = new_fitness
        self.age = new_age
        
        return self.population, self.fitness, self.age

    def survivor_selection(self, offspring, offspring_fitness):
        # Esta función ahora será reemplazada por age_based_replacement
        return self.age_based_replacement(offspring, offspring_fitness)

    def run(self):
        while self.evaluations < self.max_evals:
            parents = self.select_parents()

            offspring = self.generate_offspring(parents)

            # Evaluar solo nuevos individuos distintos
            offspring_fitness = self.evaluate_different_offspring(offspring)

            # Selección de sobrevivientes usando el reemplazo basado en edad
            self.population, self.fitness, self.age = self.survivor_selection(offspring, offspring_fitness)

            if self.elitism:
                best_idx = np.argmin(self.fitness)
                worst_idx = np.argmax(self.fitness)
                best_in_history = min(self.history, key=lambda x: x[2])[1]
                best_value = self.fitness_function(best_in_history)
                self.population[worst_idx] = best_in_history
                self.fitness[worst_idx] = best_value

        best_idx = np.argmin(self.fitness)
        return self.population[best_idx], self.fitness[best_idx], self.history