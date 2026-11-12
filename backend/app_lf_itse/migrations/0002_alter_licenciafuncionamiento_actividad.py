from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app_lf_itse', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='licenciafuncionamiento',
            name='actividad',
            field=models.CharField(max_length=250),
        ),
    ]
