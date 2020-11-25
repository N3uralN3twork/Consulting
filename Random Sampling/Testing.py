import pandas as pd


def clustering_sampling(df, n):
    df_list = []

    for i in range(len(n)):
        df1 = df[df['cluster'] == n[i]]
        df_list.append(df1)
    final_df = pd.concat(df_list, ignore_index=True)

    return final_df


clustering_sampling(df, 2)