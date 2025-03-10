from equations import Equations as eq
from methods.BaseMethod import BaseMethod as base
import pandas as pd

class Experiment:
    @staticmethod
    def experimentForOneDimension(number_of_experiments, number_of_executions):
        number_of_tweaks = int(number_of_executions / 4)
        interval = [int(number_of_executions/5), int(number_of_executions/2)]

        parameter_list = [{
            'func': eq.F1,
            'maxStep': 20,
            'number_experiments': number_of_experiments,
            'number_of_executions': number_of_executions,
            'number_of_dimensions': 1,
            'number_of_tweaks': number_of_tweaks,
            'interval': interval,
            'minDomainValue': -20,
            'maxDomainValue': 20,
            'temperature': 1000,
            'temperatureDecrease': 100,
            'maximize': False
        }, {
            'func': eq.F2,
            'maxStep': 20,
            'number_experiments': number_of_experiments,
            'number_of_executions': number_of_executions,
            'number_of_dimensions': 1,
            'number_of_tweaks': number_of_tweaks,
            'interval': interval,
            'minDomainValue': -20,
            'maxDomainValue': 20,
            'temperature': 1000,
            'temperatureDecrease': 100,
            'maximize': False
        }, {
            'func': eq.F6,
            'maxStep': 20,
            'number_experiments': number_of_experiments,
            'number_of_executions': number_of_executions,
            'number_of_dimensions': 1,
            'number_of_tweaks': number_of_tweaks,
            'interval': interval,
            'minDomainValue': -10,
            'maxDomainValue': 10,
            'temperature': 1000,
            'temperatureDecrease': 100,
            'maximize': False
        }]

        stats = Experiment.concat_stats(parameter_list)
        fileName = 'one_dimension'
        stats.to_csv(f'{fileName}.csv', index=False)

        return stats

    @staticmethod
    def concat_stats(parameter_list):
        stats = []
        for experiment_data in parameter_list:
            method_instance = base(minDomainValue=experiment_data['minDomainValue'], maxDomainValue=experiment_data['maxDomainValue'])
            hillClimbingResults, hillClimbingConvergenceList = method_instance.HillClimbing(
                experiment_data['func'],
                experiment_data['maxStep'],
                experiment_data['number_experiments'],
                experiment_data['number_of_dimensions'],
                experiment_data['maximize']
            )

            stats.append({
                'func': experiment_data['func'],
                'hyperparameters': experiment_data,
                'best_result': hillClimbingResults,
                'convergence_list': hillClimbingConvergenceList
            })
        
        return pd.DataFrame(stats)

            