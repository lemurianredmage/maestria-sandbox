import matplotlib.pyplot as plt
import ast

class GraphResults:
    @staticmethod
    def plot_convergence(df, function_labels):
        # Create a 2x2 grid of subplots
        fig, axes = plt.subplots(2, 2, figsize=(14, 10))
        
        for idx, (ax, function_data) in enumerate(zip(axes.flatten(), df)):
            # Plot for each function
            for i, algorithm_data in enumerate(function_data['convergence_list']):
                if isinstance(algorithm_data, str):
                    data = ast.literal_eval(algorithm_data)
                else:
                    data = algorithm_data
                ax.plot(range(len(data)), data, label=function_data['method'][i])
            
            # Set labels and title for each subplot
            ax.set_title(function_labels[idx])
            ax.set_xlabel('Iterations')
            ax.set_ylabel('Fitness')
            ax.legend()

        # Adjust layout to prevent overlap
        plt.tight_layout()
        plt.show()

    @staticmethod
    def prepare_results_to_graph(df):
        df_group = df.groupby('func').agg({
            'convergence_list': lambda x: list(x),  
            'method': lambda x: list(x)
        }).reset_index()

        return df_group

    @staticmethod
    def plot(df):
        df_group = GraphResults.prepare_results_to_graph(df)
        function_labels = df_group['func'].tolist()
        GraphResults.plot_convergence(df_group.to_dict(orient='records'), function_labels)
