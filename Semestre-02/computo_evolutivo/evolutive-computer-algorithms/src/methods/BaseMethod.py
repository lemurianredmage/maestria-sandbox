import random
import math

class BaseMethod:
    def __init__(self, minDomainValue, maxDomainValue):
        self.minDomainValue = minDomainValue
        self.maxDomainValue = maxDomainValue

    def Quality(self, S, func):
        return func(S)
    
    def Tweak(self, S, maxStep):
        def TweakValue(value):
            prob = random.uniform(0, 1)
            number = random.uniform(0, maxStep)

            if prob > 2/3:
                value += number
            elif prob > 1/3 and prob < 2/3:
                value -= number

            if value > self.maxDomainValue:
                value = self.maxDomainValue
            elif value < self.minDomainValue:
                value = self.minDomainValue
    
    def RandomSolution(self, numbers):
        return [random.uniform(self.minDomainValue, self.maxDomainValue) for _ in range(numbers)]
    
    def HillClimbing(self, func, maxStep, number_of_executions, number_of_dimensions, maximize=True):
        list_convergence = []
        
        S = self.RandomSolution(number_of_dimensions)
        S_Quality = self.Quality(S, func)

        for i in range(number_of_executions):
            R = self.Tweak(S, maxStep)
            R_Quality = self.Quality(R, func)

            if (maximize and R_Quality > S_Quality) or (not maximize and R_Quality < S_Quality):
                S = R
                S_Quality = R_Quality

            list_convergence.append(func(S))
        
        return S, list_convergence
    
    def SteepestAscentHillClimbing(self, func, maxStep, number_of_excecutions, number_of_dimensions, number_of_tweeks, maximize=True):
        list_convergence = []

        S = self.RandomSolution(number_of_dimensions)
        S_Quality = self.Quality(S, func)

        for i in range(number_of_excecutions):
            R = self.Tweak(S, maxStep)
            R_Quality = self.Quality(R, func)

            for t in range(number_of_tweeks):
                W = self.Tweak(S, maxStep)
                W_Quality = self.Quality(W, func)

                if (maximize and W_Quality > R_Quality) or (not maximize and W_Quality < R_Quality):
                    R = W
                    R_Quality = W_Quality

            if (maximize and R_Quality > S_Quality) or (not maximize and R_Quality < S_Quality):
                S = R
                S_Quality = R_Quality

            list_convergence.append(func(S))

        return S, list_convergence
    
    def SteepestAscentHillClimbingWithReplacement(self, func, maxStep, number_of_excecutions, number_of_dimensions, number_of_tweeks, maximize=True):
        list_convergence = []

        S = self.RandomSolution(number_of_dimensions)
        S_Quality = self.Quality(S, func)

        Best = S[:]
        Best_Quality = S_Quality

        for i in range(number_of_excecutions):
            R = self.Tweak(S, maxStep)
            R_Quality = self.Quality(R, func)

            for t in range(number_of_tweeks):
                W = self.Tweak(S, maxStep)
                W_Quality = self.Quality(W, func)

                if (maximize and W_Quality > R_Quality) or (not maximize and W_Quality < R_Quality):
                    R = W
                    R_Quality = W_Quality

            S = R
            S_Quality = R_Quality

            if (maximize and S_Quality > Best_Quality) or (not maximize and S_Quality < Best_Quality):
                Best = S[:]
                Best_Quality = S_Quality

            list_convergence.append(func(Best))

        return Best, list_convergence

    def RandomSearch(self, func, maxStep, number_of_executions, number_of_dimensions, number_of_tweeks, maximize=True):
        list_convergence = []
        
        Best = self.RandomSolution(number_of_dimensions)
        Best_Quality = self.Quality(Best, func)

        for i in range(number_of_executions):
            S = self.RandomSolution(number_of_dimensions)
            S_Quality = self.Quality(S, func)
        
            if (maximize and S_Quality > Best_Quality) or (not maximize and S_Quality < Best_Quality):
                Best = S
                Best_Quality = S_Quality
            
            list_convergence.append(func(Best))
        
        return Best, list_convergence
    
    def HillClimbingWithRandomRestarts(self, func, maxStep, number_of_executions, number_of_dimensions, number_of_tweeks, maximize=True):
        pass

    def SimmulatedAnneling(self, func, maxStep, number_of_executions, number_of_dimensions, number_of_tweeks, temperature, temperatureDecrease, maximize=True):
        list_convergence = []

        S = self.RandomSolution(number_of_dimensions)
        S_Quality = self.Quality(S, func)

        Best = S[:]
        Best_Quality = S_Quality

        for i in range(number_of_executions):
            R = self.Tweak(S, maxStep)
            R_Quality = self.Quality(R, func)

            random_number = random.randint(0, 100) / 100

            exponent = (R_Quality - S_Quality if maximize else S_Quality - R_Quality) / temperature
            exponent = max(min(exponent, 700), 700)
            exponent = round(math.e**(exponent), 2)
            condition = random_number < exponent if maximize else random_number > exponent

            if (maximize and R_Quality > S_Quality) or (not maximize and R_Quality > S_Quality) or condition:
                S = R[:]
                S_Quality = R_Quality

            temperature -= temperatureDecrease

            if temperature == 0:
                temperature = 1
            
            if (maximize and S_Quality > Best_Quality) or (not maximize and S_Quality < Best_Quality):
                Best = S[:]
                Best_Quality = S_Quality
            
            list_convergence.append(func(Best))

        return Best, list_convergence
    
    def IteratedLocalSearchWithRandomRestarts(self, func, maxStep, number_of_executions, number_of_dimensions, number_of_tweeks, maximize=True):
        pass
    
    def perturb(self, S):
        return self.Tweak(S, self.maxDomain)

