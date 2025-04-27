import numpy as np
import random

class CustomEvolutionaryAlgorithm:
    def __init__(self, fitness_function, bounds, dimension, population_size=100,
                 crossover_prob=0.9, mutation_prob=0.1, tournament_size=3, elitism=True, max_evals=10000):
        self.fitness_function = fitness_function
        self.bounds = bounds
        self.dimension = dimension
        self.population_size = population_size
        self.crossover_prob = crossover_prob
        self.mutation_prob = mutation_prob
        self.tournament_size = tournament_size
        self.elitism = elitism
        self.max_evals = max_evals

        self.population = self.initialize_population()
        self.evaluations = len(self.population)
        self.history = []
        self.fitness = np.array([self.evaluate(ind) for ind in self.population])

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
        if np.random.rand() < self.crossover_prob:
            alpha = np.random.rand()
            return alpha * parent1 + (1 - alpha) * parent2
        return parent1.copy()

    def mutate(self, individual):
        if np.random.rand() < self.mutation_prob:
            index = np.random.randint(0, self.dimension)
            mutation_strength = (self.bounds[1] - self.bounds[0]) * 0.1
            individual[index] += np.random.normal(0, mutation_strength)
            individual[index] = np.clip(individual[index], self.bounds[0], self.bounds[1])
        return individual

    def survivor_selection(self, offspring, offspring_fitness):
        combined = list(zip(self.population, self.fitness)) + list(zip(offspring, offspring_fitness))
        combined.sort(key=lambda x: x[1])
        return [ind for ind, fit in combined[:self.population_size]], [fit for ind, fit in combined[:self.population_size]]

    def run(self):
        while self.evaluations < self.max_evals:
            parents = self.select_parents()

            offspring = self.generate_offspring(parents)

            # Evaluar solo nuevos individuos distintos
            offspring_fitness = self.evaluate_different_offspring(offspring)

            self.population, self.fitness = self.survivor_selection(offspring, offspring_fitness)

            if self.elitism:
                best_idx = np.argmin(self.fitness)
                worst_idx = np.argmax(self.fitness)
                best_in_history = min(self.history, key=lambda x: x[2])[1]
                best_value = self.fitness_function(best_in_history)
                self.population[worst_idx] = best_in_history
                self.fitness[worst_idx] = best_value

        best_idx = np.argmin(self.fitness)
        return self.population[best_idx], self.fitness[best_idx], self.history