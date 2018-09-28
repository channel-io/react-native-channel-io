using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Channel.Io.RNChannelIo
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNChannelIoModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNChannelIoModule"/>.
        /// </summary>
        internal RNChannelIoModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNChannelIo";
            }
        }
    }
}
