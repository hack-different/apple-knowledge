# The Master Index

As a lineage from the Classic MacOS operating system, Apple still uses 4CC or 4 character codes pervasively.  This helps you identify an unknown 4 ASCII sequence

<table>
<thead>
    <th>Code</th>
    <th>Description</th>
</thead>
    <tbody>
{% for entry in site.data.4cc %}
    <tr>
        <td>{{ entry.code }}</td>
        <td>{{ entry.description }}</td>
    </tr>
{% endfor %}
    </tbody>
</table>