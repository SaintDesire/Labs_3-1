# Generated by Django 4.2.7 on 2023-12-19 20:19

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('main', '0005_alter_user_ban_end_date'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='car',
            table='car',
        ),
        migrations.AlterModelTable(
            name='edge',
            table='edge',
        ),
        migrations.AlterModelTable(
            name='location',
            table='location',
        ),
        migrations.AlterModelTable(
            name='node',
            table='node',
        ),
        migrations.AlterModelTable(
            name='rental',
            table='rental',
        ),
        migrations.AlterModelTable(
            name='user',
            table='user',
        ),
    ]
