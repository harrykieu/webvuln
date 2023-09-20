import matplotlib.pyplot as plt
plt.style.use('https://raw.githubusercontent.com/dhaitz/matplotlib-stylesheets/master/pitayasmoothie-dark.mplstyle')

fig = plt.figure()
# First graph
data = {
    'SQLi': 20,
    'XSS': 15,
    'File Upload': 10,
}
group_data = list(data.values())
group_names = list(data.keys())
fig1 = fig.add_subplot(1, 2, 1)
fig1.bar(group_names, group_data)
fig1.set_title('Vulnerabilities')

# Draw second graph
fig2 = fig.add_subplot(1, 2, 2)
fig2.pie([1, 2, 3, 4, 5], labels=['A', 'B', 'C', 'D', 'E'])

fig.savefig('demo_app\GUI\\asset\graph.png')