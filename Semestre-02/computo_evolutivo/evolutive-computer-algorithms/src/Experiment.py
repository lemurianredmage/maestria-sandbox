from equations import Equations as eq
from methods.BaseMethod import BaseMethod as base
import pandas as pd
import numpy as np

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
    def experimentForTwoDimensions(number_of_experiments, number_of_executions):
        number_of_tweaks = int(number_of_executions / 4)
        interval = [int(number_of_executions/5), int(number_of_executions/2)]

        parameter_list = [{
            'func': eq.F7,
            'maxStep': 20,
            'number_experiments': number_of_experiments,
            'number_of_executions': number_of_executions,
            'number_of_dimensions': 2,
            'number_of_tweaks': number_of_tweaks,
            'interval': interval,
            'minDomainValue': -20,
            'maxDomainValue': 20,
            'temperature': 1000,
            'temperatureDecrease': 100,
            'maximize': False
        }, {
            'func': eq.F12,
            'maxStep': 20,
            'number_experiments': number_of_experiments,
            'number_of_executions': number_of_executions,
            'number_of_dimensions': 2,
            'number_of_tweaks': number_of_tweaks,
            'interval': interval,
            'minDomainValue': -20,
            'maxDomainValue': 20,
            'temperature': 1000,
            'temperatureDecrease': 100,
            'maximize': False
        }, {
            'func': eq.F13,
            'maxStep': 20,
            'number_experiments': number_of_experiments,
            'number_of_executions': number_of_executions,
            'number_of_dimensions': 2,
            'number_of_tweaks': number_of_tweaks,
            'interval': interval,
            'minDomainValue': -10,
            'maxDomainValue': 10,
            'temperature': 1000,
            'temperatureDecrease': 100,
            'maximize': False
        }]

        stats = Experiment.concat_stats(parameter_list)
        fileName = 'two_dimensions'
        stats.to_csv(f'{fileName}.csv', index=False)

        return stats
    
    @staticmethod
    def experimentForMultipleDimensions(number_of_experiments, number_of_executions, dimensions = [2, 5, 10, 100, 1000]):
        number_of_tweaks = int(number_of_executions / 4)
        interval = [int(number_of_executions/5), int(number_of_executions/2)]

        parameter_list = []

        for dimension in dimensions:
            parameter_list = parameter_list + [{
                'func': eq.F3,
                'maxStep': 20,
                'number_experiments': number_of_experiments,
                'number_of_executions': number_of_executions,
                'number_of_dimensions': dimension,
                'number_of_tweaks': number_of_tweaks,
                'interval': interval,
                'minDomainValue': -20,
                'maxDomainValue': 20,
                'temperature': 1000,
                'temperatureDecrease': 100,
                'maximize': False
            }, {
                'func': eq.F4,
                'maxStep': 20,
                'number_experiments': number_of_experiments,
                'number_of_executions': number_of_executions,
                'number_of_dimensions': dimension,
                'number_of_tweaks': number_of_tweaks,
                'interval': interval,
                'minDomainValue': -20,
                'maxDomainValue': 20,
                'temperature': 1000,
                'temperatureDecrease': 100,
                'maximize': False
            }, {
                'func': eq.F5,
                'maxStep': 20,
                'number_experiments': number_of_experiments,
                'number_of_executions': number_of_executions,
                'number_of_dimensions': dimension,
                'number_of_tweaks': number_of_tweaks,
                'interval': interval,
                'minDomainValue': -10,
                'maxDomainValue': 10,
                'temperature': 1000,
                'temperatureDecrease': 100,
                'maximize': False
            }, {
                'func': eq.F11,
                'maxStep': 20,
                'number_experiments': number_of_experiments,
                'number_of_executions': number_of_executions,
                'number_of_dimensions': dimension,
                'number_of_tweaks': number_of_tweaks,
                'interval': interval,
                'minDomainValue': -10,
                'maxDomainValue': 10,
                'temperature': 1000,
                'temperatureDecrease': 100,
                'maximize': False
            }]

        stats = Experiment.concat_stats(parameter_list)
        fileName = 'multiple_dimensions'
        stats.to_csv(f'{fileName}.csv', index=False)

        return stats

    @staticmethod
    def concat_stats(parameter_list):
        stats = []
        for experiment_data in parameter_list:
            hyperparameters = experiment_data.copy()
            del hyperparameters['func']

            method_instance = base(minDomainValue=experiment_data['minDomainValue'], maxDomainValue=experiment_data['maxDomainValue'])
            hill_climbing_best_result, hill_climbing_convergence_list = method_instance.HillClimbing(
                experiment_data['func'],
                experiment_data['maxStep'],
                experiment_data['number_experiments'],
                experiment_data['number_of_dimensions'],
                experiment_data['maximize']
            )

            stats.append({
                'func': experiment_data['func'].__name__,
                'method': 'hill_climbing',
                'hyperparameters': hyperparameters,
                'number_of_dimensions': hyperparameters['number_of_dimensions'],
                'convergence_list': hill_climbing_convergence_list,
                'best_result': hill_climbing_best_result[0],
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
                'func': experiment_data['func'].__name__,
                'method': 'steepest_ascent_hill_climbing',
                'hyperparameters': hyperparameters,
                'number_of_dimensions': hyperparameters['number_of_dimensions'],
                'convergence_list': steepest_ascent_hill_climbing_convergence_list,
                'best_result': steepest_ascent_hill_climbing_best_result[0],
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
                'func': experiment_data['func'].__name__,
                'method': 'steepest_ascent_hill_climbing_with_replacement',
                'hyperparameters': hyperparameters,
                'number_of_dimensions': hyperparameters['number_of_dimensions'],
                'convergence_list': steepest_ascent_hill_climbing_with_replacement_convergence_list,
                'best_result': steepest_ascent_hill_climbing_with_replacement_best_result[0],
            })

            random_search_best_result, random_search_convergence_list = method_instance.RandomSearch(
                experiment_data['func'],
                experiment_data['number_experiments'],
                experiment_data['number_of_dimensions'],
                experiment_data['maximize']
            )

            stats.append({
                'func': experiment_data['func'].__name__,
                'method': 'random_search',
                'hyperparameters': hyperparameters,
                'number_of_dimensions': hyperparameters['number_of_dimensions'],
                'convergence_list': random_search_convergence_list,
                'best_result': random_search_best_result[0],
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
                'func': experiment_data['func'].__name__,
                'method': 'hill_climbing_with_random_restarts',
                'hyperparameters': hyperparameters,
                'number_of_dimensions': hyperparameters['number_of_dimensions'],
                'convergence_list': hill_climbing_with_random_restarts_convergence_list,
                'best_result': hill_climbing_with_random_restarts_best_result[0],
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
                'func': experiment_data['func'].__name__,
                'method': 'simmulated_anneling',
                'hyperparameters': hyperparameters,
                'number_of_dimensions': hyperparameters['number_of_dimensions'],
                'convergence_list': simmulated_anneling_convergence_list,
                'best_result': simmulated_anneling_best_result[0],
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
                'func': experiment_data['func'].__name__,
                'method': 'iterated_local_search_with_random_restarts',
                'hyperparameters': hyperparameters,
                'number_of_dimensions': hyperparameters['number_of_dimensions'],
                'convergence_list': iterated_local_search_with_random_restarts_convergence_list,
                'best_result': iterated_local_search_with_random_restarts_best_result[0],
            })
        
        stats = pd.DataFrame(stats)

        Experiment.add_stats_by_rows(stats)

        return stats

    @staticmethod
    def add_stats_by_rows(df):
        for index, row in df.iterrows():
            df.at[index, 'median'] = np.round(np.median(row.loc['convergence_list']), 6)
            df.at[index, 'mean'] = np.round(np.mean(row.loc['convergence_list']), 6)
            df.at[index, 'minimum'] = np.round(np.min(row.loc['convergence_list']), 6)
            df.at[index, 'maximum'] = np.round(np.max(row.loc['convergence_list']), 6)
            df.at[index, 'std_dev'] = np.round(np.std(row.loc['convergence_list']), 6)
            df.at[index, 'iqr'] = np.round(np.percentile(row.loc['convergence_list'], 75) - np.percentile(row.loc['convergence_list'], 25), 6)
            