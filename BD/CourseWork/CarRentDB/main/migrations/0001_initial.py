# Generated by Django 4.2.7 on 2023-12-18 11:56

import datetime
import django.contrib.gis.db.models.fields
import django.core.validators
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Car',
            fields=[
                ('car_id', models.AutoField(primary_key=True, serialize=False)),
                ('brand', models.CharField(default=None, max_length=50)),
                ('model', models.CharField(default=None, max_length=50)),
                ('color', models.CharField(default=None, max_length=20)),
                ('year', models.IntegerField()),
                ('status', models.CharField(default=None, max_length=20)),
                ('number', models.CharField(default='Unknown', max_length=20)),
                ('is_free', models.BooleanField(default=True)),
                ('price', models.DecimalField(decimal_places=2, default=5, max_digits=8)),
            ],
        ),
        migrations.CreateModel(
            name='Location',
            fields=[
                ('location_id', models.AutoField(primary_key=True, serialize=False)),
                ('address', models.CharField(max_length=100)),
                ('geom', django.contrib.gis.db.models.fields.PointField(default=None, srid=4326)),
            ],
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('user_id', models.AutoField(primary_key=True, serialize=False)),
                ('first_name', models.CharField(default=None, max_length=50)),
                ('last_name', models.CharField(default=None, max_length=50)),
                ('email', models.CharField(default=None, max_length=100)),
                ('phone', models.CharField(default=None, max_length=20)),
                ('password', models.CharField(default=None, max_length=128)),
                ('role', models.CharField(choices=[('user', 'User'), ('admin', 'Admin')], default='user', max_length=50)),
                ('ban_end_date', models.DateField(blank=True, null=True, validators=[django.core.validators.MinValueValidator(limit_value=datetime.date(2023, 12, 19))])),
                ('is_active', models.BooleanField(default=True)),
                ('address', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to='main.location')),
            ],
        ),
        migrations.CreateModel(
            name='Rental',
            fields=[
                ('rental_id', models.AutoField(primary_key=True, serialize=False)),
                ('start_date', models.DateField()),
                ('end_date', models.DateField()),
                ('total_cost', models.DecimalField(decimal_places=2, max_digits=10)),
                ('car', models.ForeignKey(default=None, on_delete=django.db.models.deletion.CASCADE, to='main.car')),
                ('user', models.ForeignKey(default=None, on_delete=django.db.models.deletion.CASCADE, to='main.user')),
            ],
        ),
        migrations.AddField(
            model_name='car',
            name='location',
            field=models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to='main.location'),
        ),
    ]
