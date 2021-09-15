using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using CPU_Catalog3.Controller;
using CPU_Catalog3.LangResource;

namespace CPU_Catalog3.View
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class SettingsPage : ContentPage
    {
        public NoScrollTabbedPage ParentPage { get; set; }

        public SettingsPage()
        {
            InitializeComponent();

            foreach (var language in LanguageController.AppLanguages)
            {
                langPicker.Items.Add(language.Title);
            }
            langPicker.SelectedIndex = 0;

            foreach (var theme in ColorController.AppThemes)
            {
                themePicker.Items.Add(theme.Title);
            }
            themePicker.SelectedIndex = 0;

            Resources = DependencyService.Resolve<ResourceDictionary>();
            

            Fonts.SelectedItem = Resources["FontFamily"];
            Size.Value = Convert.ToDouble(Resources["FontSize"]);

        }

        private void ThemePicker_SelectedIndexChanged(object sender, EventArgs e)
        {
            ColorController.ChangeTheme(themePicker.SelectedIndex);
            if (ParentPage != null)
                this.ParentPage.ReColor();
            OnAppearing();
        }

        protected override void OnAppearing()
        {
            ReColor();
        }

        private void ReColor()
        {
            this.BackgroundColor = ColorController.CurrentTheme.BackColor;

            settingsLabel.TextColor = ColorController.CurrentTheme.BackColor;
            settingsLabel.BackgroundColor = ColorController.CurrentTheme.AddColor;

            interfaceFrame.BackgroundColor = ColorController.CurrentTheme.BackColor;
            interfaceFrame.BorderColor = ColorController.CurrentTheme.AddColor;

            interfaceLabel.TextColor = ColorController.CurrentTheme.FontColor;

            langPicker.TextColor = ColorController.CurrentTheme.FontColor;
            langLabel.TextColor = ColorController.CurrentTheme.FontColor;
            themeLabel.TextColor = ColorController.CurrentTheme.FontColor;
            themePicker.TextColor = ColorController.CurrentTheme.FontColor;
            FontLabel.TextColor = ColorController.CurrentTheme.FontColor;
            Fonts.TextColor = ColorController.CurrentTheme.FontColor;
        }

        private void LangPicker_SelectedIndexChanged(object sender, EventArgs e)
        {
            LanguageController.SetNewCulture(langPicker.SelectedIndex);
            ReTranslate();
        }


        private void Size_OnValueChanged(object sender, ValueChangedEventArgs e)
        {
            Size.Value = Math.Round(Size.Value);
            Resources["FontSize"] = Convert.ToInt32(Size.Value);
        }

        private void Fonts_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            Resources["FontFamily"] = Fonts.SelectedItem;
        }

        private void ReTranslate()
        {
            settingsLabel.Text = Resource.settingsLabelT;
            interfaceLabel.Text = Resource.interfaceLabelT;
            langLabel.Text = Resource.languageLabelT;
            themeLabel.Text = Resource.themeLabelT;
            FontLabel.Text = Resource.fontLabel;
        }
    }
}