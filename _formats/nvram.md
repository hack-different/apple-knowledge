# NVRAM Variables

Non-Volatile RAM (NVRAM) variable names, types, and platform support.

## Scopes

<table>
    <thead>
    <tr>
        <th>Scope</th>
        <th>UUID</th>
        <th>Description</th>
    </tr>
    </thead>
    <tbody>
    {% for entry in site.data.nvram.nvram_scopes %}
    <tr>
        <td><code>{{ entry[0] }}</code></td>
        <td><code>{{ entry[1].uuid }}</code></td>
        <td>{{ entry[1].description }}</td>
    </tr>
    {% endfor %}
    </tbody>
</table>

## Variables

{% include nvram_table.html %}
