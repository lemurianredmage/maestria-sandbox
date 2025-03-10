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
            hill_climbing_best_result, hill_climbing_convergence_list = method_instance.HillClimbing(
                experiment_data['func'],
                experiment_data['maxStep'],
                experiment_data['number_experiments'],
                experiment_data['number_of_dimensions'],
                experiment_data['maximize']
            )

            stats.append({
                'func': experiment_data['func'],
                'method': 'hill_climbing',
                'hyperparameters': experiment_data,
                'best_result': hill_climbing_best_result,
                'convergence_list': hill_climbing_convergence_list
            })

            steepest_ascent_hill_climbing_best_result, steepest_ascent_hill_climbing_convergence_list = method_instance.SteepestAscentHillClimbing(
                experiment_data['func'],
                experiment_data['maxStep'],
                experiment_data['number_experiments'],
                experiment_data['number_of_dimensions'],
                experiment_data['number_of_tweaks'],
                experiment_data['maximize']
            )

            stats.append({
                'func': experiment_data['func'],
                'method': 'steepest_ascent_hill_climbing',
                'hyperparameters': experiment_data,
                'best_result': steepest_ascent_hill_climbing_best_result,
                'convergence_list': steepest_ascent_hill_climbing_convergence_list
            })

            steepest_ascent_hill_climbing_with_replacement_best_result, steepest_ascent_hill_climbing_with_replacement_convergence_list = method_instance.SteepestAscentHillClimbingWithReplacement(
                experiment_data['func'],
                experiment_data['maxStep'],
                experiment_data['number_experiments'],
                experiment_data['number_of_dimensions'],
                experiment_data['number_of_tweaks'],
                experiment_data['maximize']
            )

            stats.append({
                'func': experiment_data['func'],
                'method': 'steepest_ascent_hill_climbing_with_replacement',
                'hyperparameters': experiment_data,
                'best_result': steepest_ascent_hill_climbing_with_replacement_best_result,
                'convergence_list': steepest_ascent_hill_climbing_with_replacement_convergence_list
            })

            random_search_best_result, random_search_convergence_list = method_instance.RandomSearch(
                experiment_data['func'],
                experiment_data['number_experiments'],
                experiment_data['number_of_dimensions'],
                experiment_data['maximize']
            )

            stats.append({
                'func': experiment_data['func'],
                'method': 'random_search',
                'hyperparameters': experiment_data,
                'best_result': random_search_best_result,
                'convergence_list': random_search_convergence_list
            })

            hill_climbing_with_random_restarts_best_result, hill_climbing_with_random_restarts_convergence_list = method_instance.HillClimbingWithRandomRestarts(
                experiment_data['func'],
                experiment_data['maxStep'],
                experiment_data['number_experiments'],
                experiment_data['number_of_dimensions'],
                experiment_data['interval'],
                experiment_data['maximize']
            )

            stats.append({
                'func': experiment_data['func'],
                'method': 'hill_climbing_with_random_restarts',
                'hyperparameters': experiment_data,
                'best_result': hill_climbing_with_random_restarts_best_result,
                'convergence_list': hill_climbing_with_random_restarts_convergence_list
            })

            simmulated_anneling_best_result, simmulated_anneling_convergence_list = method_instance.SimmulatedAnneling(
                experiment_data['func'],
                experiment_data['maxStep'],
                experiment_data['number_experiments'],
                experiment_data['number_of_dimensions'],
                experiment_data['temperature'],
                experiment_data['temperatureDecrease'],
                experiment_data['maximize']
            )

            stats.append({
                'func': experiment_data['func'],
                'method': 'simmulated_anneling',
                'hyperparameters': experiment_data,
                'best_result': simmulated_anneling_best_result,
                'convergence_list': simmulated_anneling_convergence_list
            })

            iterated_local_search_with_random_restarts_best_result, iterated_local_search_with_random_restarts_convergence_list = method_instance.IteratedLocalSearchWithRandomRestarts(
                experiment_data['func'],
                experiment_data['maxStep'],
                experiment_data['number_experiments'],
                experiment_data['number_of_dimensions'],
                experiment_data['interval'],
                experiment_data['maximize']
            )

            stats.append({
                'func': experiment_data['func'],
                'method': 'iterated_local_search_with_random_restarts',
                'hyperparameters': experiment_data,
                'best_result': iterated_local_search_with_random_restarts_best_result,
                'convergence_list': iterated_local_search_with_random_restarts_convergence_list
            })
        
        return pd.DataFrame(stats)

            