import matplotlib.pyplot as plt


def plot_z_T(listaz, listaT, ax = None, set_axis=False, **kwargs):
    fig, ax = plt.subplots()
    ax.plot(listaz, listaT, **kwargs)
    if set_axis:
        ax.set_xlabel('Z(m)')
        ax.set_ylabel('T (ºC)')
    return fig, ax
    
    