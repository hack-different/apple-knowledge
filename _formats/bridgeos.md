# bridgeOS Properties & Services

Properties and services exposed by Apple T2 coprocessors running bridgeOS.

## Local Properties & Services

{% include bridgeos_table.html %}

## Remote Properties

<table>
    <thead>
    <tr>
        <th>Remote Property</th>
        <th>Description</th>
    </tr>
    </thead>
    <tbody>
    {% for entry in site.data.bridgeos.remote_properties %}
    <tr>
        <td><code>{{ entry[0] }}</code></td>
        <td>{{ entry[1].description }}</td>
    </tr>
    {% endfor %}
    </tbody>
</table>

## Remote Services

<table>
    <thead>
    <tr>
        <th>Remote Service</th>
        <th>Description</th>
    </tr>
    </thead>
    <tbody>
    {% for entry in site.data.bridgeos.remote_services %}
    <tr>
        <td><code>{{ entry[0] }}</code></td>
        <td>{{ entry[1].description }}</td>
    </tr>
    {% endfor %}
    </tbody>
</table>
