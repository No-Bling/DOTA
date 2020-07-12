using System; using System.Collections.Generic; using System.Diagnostics; using System.IO; using System.Windows.Forms;
using System.Drawing; using System.Linq; using System.Reflection; using System.Security.Cryptography; using System.Text;
using System.Net; using SteamDatabase.ValvePak; using SteamKit.KeyValue; [assembly:AssemblyDescriptionAttribute(@"
        `````` `````````     ` ````````````````````````````````````` ``
       ``:#################:`````````:#########:``````:############:``:#######:`
       ``:######################################:``:#######################:``
       ```:#############################################################:```
       ```:#############################################################:```
       ```:#############################################################:```
      ````:########:````:################################:```:##############:```
       ``:########:```````:#######################:````````````:#############:```
      ```:##########:````````:#####################:``` `    ```:############:```
       ``:############:```  `````:####################:````  ``:#############:``
      ```:##############:```  ``````:###################:``````:#############:``
       ```:###############:``    `````:####################:```:############:```
        ``:################:```       ````:##############################:``
        ``:##################:````      `````:##########################:```
        ``:####################:```       ` ```:#########################:```
        ``:######################:```         ````:#######################:``
        ```:#######################:````        `````:####################:```
       ```:##########################:```           ````:#################:```
       ``:#############################:```            ````:##############:```
       ``:##############################:````            `````:############:``
       ``:###########:``:###################:````             `````:#########:```
       ```:#########:`````:####################:```               ``:########:``
         ``:#######:``` ````:###################:````            ```:########:```
        ```:#######:```    ```:###################:````          ``:#########:```
       ```:#######:```      ````:###################:```        ``:##########:``
       ``:#########:```     ``````:###################:```` `  ```:##########:`` `
       ``:###########:`````````:######################:```````:###########:```
       ``:###############################################################:```
       ``:###############################################################:```
      ```:###############################                       #########:`` `
       ``:###############################:  No-: Bling : DOTA mod  :#########:```
      ````:##############################                       #########:` `
       `````````````````````````:##:```:#############################:````:##:```
          ` ``` ```` ` ` ````````` ````````````````````````````````  ````")]
[assembly:AssemblyVersionAttribute("2020.07.08.2")] [assembly: AssemblyTitle("AveYo")]

namespace SteamDatabase.ValvePak
{
    /*
    VPKMOD Copyright (c) 2019 AveYo
    Extending ValvePak library by SteamDatabase Team

    MIT License

    Copyright (c) 2016 Steam Database

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
    */

    internal static class StreamHelpers
    {
        public static string ReadNullTermString(this BinaryReader stream, Encoding encoding)
        {
            var characterSize = encoding.GetByteCount("e");
            using (var ms = new MemoryStream())
            {
                while (true)
                {
                    var data = new byte[characterSize];
                    stream.Read(data, 0, characterSize);
                    if (encoding.GetString(data, 0, characterSize) == "\0")
                        break;
                    ms.Write(data, 0, data.Length);
                }
                return encoding.GetString(ms.ToArray());
            }
        }
    }

    public static class Crc32
    {
        // CRC polynomial 0xEDB88320.
        private static readonly uint[] Table =
        {
           0x00000000, 0x77073096, 0xEE0E612C, 0x990951BA, 0x076DC419, 0x706AF48F, 0xE963A535, 0x9E6495A3, 0x0EDB8832, 0x79DCB8A4,
           0xE0D5E91E, 0x97D2D988, 0x09B64C2B, 0x7EB17CBD, 0xE7B82D07, 0x90BF1D91, 0x1DB71064, 0x6AB020F2, 0xF3B97148, 0x84BE41DE,
           0x1ADAD47D, 0x6DDDE4EB, 0xF4D4B551, 0x83D385C7, 0x136C9856, 0x646BA8C0, 0xFD62F97A, 0x8A65C9EC, 0x14015C4F, 0x63066CD9,
           0xFA0F3D63, 0x8D080DF5, 0x3B6E20C8, 0x4C69105E, 0xD56041E4, 0xA2677172, 0x3C03E4D1, 0x4B04D447, 0xD20D85FD, 0xA50AB56B,
           0x35B5A8FA, 0x42B2986C, 0xDBBBC9D6, 0xACBCF940, 0x32D86CE3, 0x45DF5C75, 0xDCD60DCF, 0xABD13D59, 0x26D930AC, 0x51DE003A,
           0xC8D75180, 0xBFD06116, 0x21B4F4B5, 0x56B3C423, 0xCFBA9599, 0xB8BDA50F, 0x2802B89E, 0x5F058808, 0xC60CD9B2, 0xB10BE924,
           0x2F6F7C87, 0x58684C11, 0xC1611DAB, 0xB6662D3D, 0x76DC4190, 0x01DB7106, 0x98D220BC, 0xEFD5102A, 0x71B18589, 0x06B6B51F,
           0x9FBFE4A5, 0xE8B8D433, 0x7807C9A2, 0x0F00F934, 0x9609A88E, 0xE10E9818, 0x7F6A0DBB, 0x086D3D2D, 0x91646C97, 0xE6635C01,
           0x6B6B51F4, 0x1C6C6162, 0x856530D8, 0xF262004E, 0x6C0695ED, 0x1B01A57B, 0x8208F4C1, 0xF50FC457, 0x65B0D9C6, 0x12B7E950,
           0x8BBEB8EA, 0xFCB9887C, 0x62DD1DDF, 0x15DA2D49, 0x8CD37CF3, 0xFBD44C65, 0x4DB26158, 0x3AB551CE, 0xA3BC0074, 0xD4BB30E2,
           0x4ADFA541, 0x3DD895D7, 0xA4D1C46D, 0xD3D6F4FB, 0x4369E96A, 0x346ED9FC, 0xAD678846, 0xDA60B8D0, 0x44042D73, 0x33031DE5,
           0xAA0A4C5F, 0xDD0D7CC9, 0x5005713C, 0x270241AA, 0xBE0B1010, 0xC90C2086, 0x5768B525, 0x206F85B3, 0xB966D409, 0xCE61E49F,
           0x5EDEF90E, 0x29D9C998, 0xB0D09822, 0xC7D7A8B4, 0x59B33D17, 0x2EB40D81, 0xB7BD5C3B, 0xC0BA6CAD, 0xEDB88320, 0x9ABFB3B6,
           0x03B6E20C, 0x74B1D29A, 0xEAD54739, 0x9DD277AF, 0x04DB2615, 0x73DC1683, 0xE3630B12, 0x94643B84, 0x0D6D6A3E, 0x7A6A5AA8,
           0xE40ECF0B, 0x9309FF9D, 0x0A00AE27, 0x7D079EB1, 0xF00F9344, 0x8708A3D2, 0x1E01F268, 0x6906C2FE, 0xF762575D, 0x806567CB,
           0x196C3671, 0x6E6B06E7, 0xFED41B76, 0x89D32BE0, 0x10DA7A5A, 0x67DD4ACC, 0xF9B9DF6F, 0x8EBEEFF9, 0x17B7BE43, 0x60B08ED5,
           0xD6D6A3E8, 0xA1D1937E, 0x38D8C2C4, 0x4FDFF252, 0xD1BB67F1, 0xA6BC5767, 0x3FB506DD, 0x48B2364B, 0xD80D2BDA, 0xAF0A1B4C,
           0x36034AF6, 0x41047A60, 0xDF60EFC3, 0xA867DF55, 0x316E8EEF, 0x4669BE79, 0xCB61B38C, 0xBC66831A, 0x256FD2A0, 0x5268E236,
           0xCC0C7795, 0xBB0B4703, 0x220216B9, 0x5505262F, 0xC5BA3BBE, 0xB2BD0B28, 0x2BB45A92, 0x5CB36A04, 0xC2D7FFA7, 0xB5D0CF31,
           0x2CD99E8B, 0x5BDEAE1D, 0x9B64C2B0, 0xEC63F226, 0x756AA39C, 0x026D930A, 0x9C0906A9, 0xEB0E363F, 0x72076785, 0x05005713,
           0x95BF4A82, 0xE2B87A14, 0x7BB12BAE, 0x0CB61B38, 0x92D28E9B, 0xE5D5BE0D, 0x7CDCEFB7, 0x0BDBDF21, 0x86D3D2D4, 0xF1D4E242,
           0x68DDB3F8, 0x1FDA836E, 0x81BE16CD, 0xF6B9265B, 0x6FB077E1, 0x18B74777, 0x88085AE6, 0xFF0F6A70, 0x66063BCA, 0x11010B5C,
           0x8F659EFF, 0xF862AE69, 0x616BFFD3, 0x166CCF45, 0xA00AE278, 0xD70DD2EE, 0x4E048354, 0x3903B3C2, 0xA7672661, 0xD06016F7,
           0x4969474D, 0x3E6E77DB, 0xAED16A4A, 0xD9D65ADC, 0x40DF0B66, 0x37D83BF0, 0xA9BCAE53, 0xDEBB9EC5, 0x47B2CF7F, 0x30B5FFE9,
           0xBDBDF21C, 0xCABAC28A, 0x53B39330, 0x24B4A3A6, 0xBAD03605, 0xCDD70693, 0x54DE5729, 0x23D967BF, 0xB3667A2E, 0xC4614AB8,
           0x5D681B02, 0x2A6F2B94, 0xB40BBE37, 0xC30C8EA1, 0x5A05DF1B, 0x2D02EF8D
        };

        public static uint Compute(byte[] buffer)
        {
            uint crc = 0xFFFFFFFF;
            var bufferLength = buffer.Length;
            for (var i = 0; i < bufferLength; i++)
            {
                crc = (crc >> 8) ^ Table[buffer[i] ^ (crc & 0xff)];
            }
            return ~crc;
        }
    }

    public class ArchiveMD5SectionEntry
    {
        public uint ArchiveIndex { get; set; }
        public uint Offset { get; set; }
        public uint Length { get; set; }
        public byte[] Checksum { get; set; }
    }

    public class PackageEntry
    {
        public string FileName { get; set; }
        public string DirectoryName { get; set; }
        public string TypeName { get; set; }
        public uint CRC32 { get; set; }
        public uint Length { get; set; }
        public uint Offset { get; set; }
        public ushort ArchiveIndex { get; set; }
        public uint TotalLength { get { return SmallData == null ? Length : Length + (uint)SmallData.Length; } }
        public byte[] SmallData { get; set; }

        public string GetFileName()
        {
            return TypeName == " " ? FileName : FileName + "." + TypeName;
        }

        public string GetFullPath()
        {
            return DirectoryName == " " ? GetFileName() : DirectoryName + Package.DirectorySeparatorChar + GetFileName();
        }

        public override string ToString()
        {
            return String.Format("{0} crc=0x{1:x2} metadatasz={2} fnumber={3} ofs=0x{4:x2} sz={5}",
              GetFullPath(), CRC32, SmallData.Length, ArchiveIndex, Offset, Length);
        }
    }

    public class Package : IDisposable
    {
        /*
         * Read() function was mostly taken from Rick's Gibbed.Valve.FileFormats,
         * which is subject to this license:
         *
         * Copyright (c) 2008 Rick (rick 'at' gibbed 'dot' us)
         *
         * This software is provided 'as-is', without any express or implied
         * warranty. In no event will the authors be held liable for any damages
         * arising from the use of this software.
         *
         * Permission is granted to anyone to use this software for any purpose,
         * including commercial applications, and to alter it and redistribute it
         * freely, subject to the following restrictions:
         *
         * 1. The origin of this software must not be misrepresented; you must not
         * claim that you wrote the original software. If you use this software
         * in a product, an acknowledgment in the product documentation would be
         * appreciated but is not required.
         *
         * 2. Altered source versions must be plainly marked as such, and must not be
         * misrepresented as being the original software.
         *
         * 3. This notice may not be removed or altered from any source
         * distribution.
         */

        public const int MAGIC = 0x55AA1234;
        public const char DirectorySeparatorChar = '/';
        private BinaryReader Reader;
        private bool IsDirVPK;
        private uint HeaderSize;
        public string FileName { get; private set; }
        public uint Version { get; private set; }
        public uint TreeSize { get; private set; }
        public uint FileDataSectionSize { get; private set; }
        public uint ArchiveMD5SectionSize { get; private set; }
        public uint OtherMD5SectionSize { get; private set; }
        public uint SignatureSectionSize { get; private set; }
        public byte[] TreeChecksum { get; private set; }
        public byte[] ArchiveMD5EntriesChecksum { get; private set; }
        public byte[] WholeFileChecksum { get; private set; }
        public byte[] PublicKey { get; private set; }
        public byte[] Signature { get; private set; }
        public Dictionary<string,List<PackageEntry>> Entries { get; private set; }
        public List<ArchiveMD5SectionEntry> ArchiveMD5Entries { get; private set; }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing && Reader != null)
            {
                Reader.Dispose();
                Reader = null;
            }
        }

        public void SetFileName(string fileName)
        {
            if (fileName.EndsWith(".vpk", StringComparison.OrdinalIgnoreCase))
            {
                fileName = fileName.Substring(0, fileName.Length - 4);
            }

            if (fileName.EndsWith("_dir", StringComparison.OrdinalIgnoreCase))
            {
                IsDirVPK = true;
                fileName = fileName.Substring(0, fileName.Length - 4);
            }

            FileName = fileName;
        }

        public void Read(string filename)
        {
            SetFileName(filename);

            var fs = new FileStream(String.Format("{0}{1}.vpk", FileName, IsDirVPK ? "_dir" : ""),
              FileMode.Open, FileAccess.Read, FileShare.ReadWrite);

            Read(fs);
        }

        public void Read(Stream input)
        {
            if (FileName == null)
                throw new InvalidOperationException("You must call SetFileName() before calling Read() directly with a stream.");

            Reader = new BinaryReader(input);

            if (Reader.ReadUInt32() != MAGIC)
                throw new InvalidDataException("Given file is not a VPK.");

            Version = Reader.ReadUInt32();
            TreeSize = Reader.ReadUInt32();

            if (Version == 1)
            {
                // Nothing else
            }
            else if (Version == 2)
            {
                FileDataSectionSize = Reader.ReadUInt32();
                ArchiveMD5SectionSize = Reader.ReadUInt32();
                OtherMD5SectionSize = Reader.ReadUInt32();
                SignatureSectionSize = Reader.ReadUInt32();
            }
            else
            {
                throw new InvalidDataException(String.Format("Bad VPK version. ({0})", Version));
            }

            HeaderSize = (uint)input.Position;

            ReadEntries();

            if (Version == 2)
            {
                // Skip over file data, if any
                input.Position += FileDataSectionSize;

                ReadArchiveMD5Section();
                ReadOtherMD5Section();
                ReadSignatureSection();
            }
        }

        public PackageEntry FindEntry(string filePath)
        {
            if (filePath == null)
                throw new ArgumentNullException("filePath");

            filePath = filePath.Replace('\\', DirectorySeparatorChar);

            var lastSeparator = filePath.LastIndexOf(DirectorySeparatorChar);
            var directory = lastSeparator > -1 ? filePath.Substring(0, lastSeparator) : "";
            var fileName = filePath.Substring(lastSeparator + 1);

            return FindEntry(directory, fileName);
        }

        public PackageEntry FindEntry(string directory, string fileName)
        {
            if (directory == null)
                throw new ArgumentNullException("directory");

            if (fileName == null)
                throw new ArgumentNullException("fileName");

            var dot = fileName.LastIndexOf('.');
            string extension;

            if (dot > -1)
            {
                extension = fileName.Substring(dot + 1);
                fileName = fileName.Substring(0, dot);
            }
            else
            {
                // Valve uses a space for missing extensions
                extension = " ";
            }

            return FindEntry(directory, fileName, extension);
        }

        public PackageEntry FindEntry(string directory, string fileName, string extension)
        {
            if (directory == null)
                throw new ArgumentNullException("directory");

            if (fileName == null)
                throw new ArgumentNullException("fileName");

            if (extension == null)
                throw new ArgumentNullException("extension");

            if (!Entries.ContainsKey(extension))
                return null;

            // We normalize path separators when reading the file list
            // And remove the trailing slash
            directory = directory.Replace('\\', DirectorySeparatorChar).Trim(DirectorySeparatorChar);

            // If the directory is empty after trimming, set it to a space to match Valve's behaviour
            if (directory.Length == 0)
                directory = " ";

            return Entries[extension].Find(_ => _.DirectoryName == directory && _.FileName == fileName);
        }

        public void ReadEntry(PackageEntry entry, out byte[] output, bool validateCrc = true)
        {
            output = new byte[entry.SmallData.Length + entry.Length];

            if (entry.SmallData.Length > 0)
                entry.SmallData.CopyTo(output, 0);

            if (entry.Length > 0)
            {
                Stream fs = null;

                try
                {
                    var offset = entry.Offset;

                    if (entry.ArchiveIndex != 0x7FFF)
                    {
                        if (!IsDirVPK)
                            throw new InvalidOperationException("Given VPK is not _dir, but entry references external archive.");

                        var fileName = String.Format("{0}_{1:d3}.vpk", FileName, entry.ArchiveIndex);
                        fs = new FileStream(fileName, FileMode.Open, FileAccess.Read);
                    }
                    else
                    {
                        fs = Reader.BaseStream;
                        offset += HeaderSize + TreeSize;
                    }

                    fs.Seek(offset, SeekOrigin.Begin);
                    fs.Read(output, entry.SmallData.Length, (int)entry.Length);
                }
                finally
                {
                    if (entry.ArchiveIndex != 0x7FFF && fs != null)
                        fs.Close();
                }
            }

            if (validateCrc && entry.CRC32 != Crc32.Compute(output))
                throw new InvalidDataException("CRC32 mismatch for read data.");
        }

        private void ReadEntries()
        {
            var typeEntries = new Dictionary<string, List<PackageEntry>>();

            // Types
            while (true)
            {
                var typeName = Reader.ReadNullTermString(Encoding.UTF8);

                if (typeName == null || typeName.Length == 0)
                    break;

                var entries = new List<PackageEntry>();

                // Directories
                while (true)
                {
                    var directoryName = Reader.ReadNullTermString(Encoding.UTF8);

                    if (directoryName == null || directoryName.Length == 0)
                        break;

                    // Files
                    while (true)
                    {
                        var fileName = Reader.ReadNullTermString(Encoding.UTF8);

                        if (fileName == null || fileName.Length == 0)
                            break;

                        var entry = new PackageEntry
                        {
                            FileName = fileName,
                            DirectoryName = directoryName,
                            TypeName = typeName,
                            CRC32 = Reader.ReadUInt32(),
                            SmallData = new byte[Reader.ReadUInt16()],
                            ArchiveIndex = Reader.ReadUInt16(),
                            Offset = Reader.ReadUInt32(),
                            Length = Reader.ReadUInt32()
                        };

                        if (Reader.ReadUInt16() != 0xFFFF)
                            throw new FormatException("VPK entry with invalid terminator.");

                        if (entry.SmallData.Length > 0)
                            Reader.Read(entry.SmallData, 0, entry.SmallData.Length);

                        entries.Add(entry);
                    }
                }

                typeEntries.Add(typeName, entries);
            }

            Entries = typeEntries;
        }

        public void VerifyHashes()
        {
            if (Version != 2)
                throw new InvalidDataException("Only version 2 is supported.");

            using (var md5 = MD5.Create())
            {
                Reader.BaseStream.Position = 0;

                var hash = md5.ComputeHash(
                  Reader.ReadBytes((int)(HeaderSize + TreeSize + FileDataSectionSize + ArchiveMD5SectionSize + 32)));

                if (!hash.SequenceEqual(WholeFileChecksum))
                    throw new InvalidDataException(String.Format("Package checksum mismatch ({0} != expected {1})",
                      BitConverter.ToString(hash), BitConverter.ToString(WholeFileChecksum)));

                Reader.BaseStream.Position = HeaderSize;

                hash = md5.ComputeHash(Reader.ReadBytes((int)TreeSize));

                if (!hash.SequenceEqual(TreeChecksum))
                    throw new InvalidDataException(String.Format("File tree checksum mismatch ({0} != expected {1})",
                      BitConverter.ToString(hash), BitConverter.ToString(TreeChecksum)));

                Reader.BaseStream.Position = HeaderSize + TreeSize + FileDataSectionSize;

                hash = md5.ComputeHash(Reader.ReadBytes((int)ArchiveMD5SectionSize));

                if (!hash.SequenceEqual(ArchiveMD5EntriesChecksum))
                    throw new InvalidDataException(String.Format("Archive MD5 entries checksum mismatch ({0} != expected {1})",
                      BitConverter.ToString(hash), BitConverter.ToString(ArchiveMD5EntriesChecksum)));

                // TODO: verify archive checksums
            }

            if (PublicKey == null || Signature == null)
                return;

            if (!IsSignatureValid())
                throw new InvalidDataException("VPK signature is not valid.");
        }

        public bool IsSignatureValid()
        {
            // AveYo : just return true since RSA and AsnKeyParser are not used in VPKMOD
            return true;
        }

        private void ReadArchiveMD5Section()
        {
            ArchiveMD5Entries = new List<ArchiveMD5SectionEntry>();

            if (ArchiveMD5SectionSize == 0)
                return;

            var entries = ArchiveMD5SectionSize / 28; // 28 is sizeof(VPK_MD5SectionEntry), which is int + int + int + 16 chars

            for (var i = 0; i < entries; i++)
            {
                ArchiveMD5Entries.Add(new ArchiveMD5SectionEntry
                {
                    ArchiveIndex = Reader.ReadUInt32(),
                    Offset = Reader.ReadUInt32(),
                    Length = Reader.ReadUInt32(),
                    Checksum = Reader.ReadBytes(16)
                });
            }
        }

        private void ReadOtherMD5Section()
        {
            if (OtherMD5SectionSize != 48)
                throw new InvalidDataException(String.Format("Encountered OtherMD5Section with size of {0} (should be 48)",
                  OtherMD5SectionSize));

            TreeChecksum = Reader.ReadBytes(16);
            ArchiveMD5EntriesChecksum = Reader.ReadBytes(16);
            WholeFileChecksum = Reader.ReadBytes(16);
        }

        private void ReadSignatureSection()
        {
            if (SignatureSectionSize == 0)
                return;

            var publicKeySize = Reader.ReadInt32();
            PublicKey = Reader.ReadBytes(publicKeySize);

            var signatureSize = Reader.ReadInt32();
            Signature = Reader.ReadBytes(signatureSize);
        }

        // AveYo: enhanced rework of my previous stand-alone vpk writer to fit in the Package class
        public void SaveToFile(string fn)
        {
            // VPKMOD20 just counts offsets for duplicate files, so the exported .vpk is generally smaller for repetitive content!
            var sw = Stopwatch.StartNew();
            Directory.CreateDirectory(Path.GetDirectoryName(fn)); File.Delete(fn);
            using (var sha1 = SHA1.Create())
            using (FileStream fs = new FileStream(fn, FileMode.Create, FileAccess.Write))
            using (MemoryStream mtree = new MemoryStream(), mdata = new MemoryStream())
            using (BinaryWriter tree = new BinaryWriter(mtree), data = new BinaryWriter(mdata))
            {
                uint version = 1, tree_size = 0, data_offset = 0, lookup_offset = 0;
                short preload_bytes = 0, archive_index = 0x7fff, terminator = -1;
                byte zero = 0;
                bool unique = true;
                var seen = new Dictionary<string, uint>();
                data.Write(0x4d4b5056); data.Write(0x3032444f); data_offset += 8;            // ID
                tree.Write(MAGIC);                                                           // Signature          4
                tree.Write(version);                                                         // Version            4
                tree.Write(tree_size);                                                       // TreeSize (TBD)     4

                foreach (string etype in Entries.Keys)
                {
                    tree.Write(Encoding.UTF8.GetBytes(etype));                               // TypeName           ?
                    tree.Write(zero);                                                        // 00                 1
                    tree_size += (uint)etype.Length + 1;

                    var directories = Entries[etype].Select(_ => _.DirectoryName).Distinct();
                    foreach (string dirname in directories)
                    {
                        tree.Write(Encoding.UTF8.GetBytes(dirname));                         // DirectoryName      ?
                        tree.Write(zero);                                                    // 00                 1
                        tree_size += (uint)dirname.Length + 1;

                        var files = Entries[etype].Where(_ => _.DirectoryName == dirname).Select(_ => _.FileName);
                        foreach (string filename in files)
                        {
                            byte[] data_bytes;
                            var found = Entries[etype].Find(_ => _.DirectoryName == dirname && _.FileName == filename);

                            if (found != null)
                                ReadEntry(found, out data_bytes, false); // it should always be found
                            else
                                data_bytes = new byte[0];

                            uint data_length = (uint)data_bytes.Length;
                            uint crc = Crc32.Compute(data_bytes);
                            string hash = String.Join("", sha1.ComputeHash(data_bytes));
                            if (seen.ContainsKey(hash))
                            {
                                unique = false; lookup_offset = seen[hash];
                            }
                            else
                            {
                                unique = true; lookup_offset = data_offset; seen.Add(hash, data_offset);
                            }
                            tree.Write(Encoding.UTF8.GetBytes(filename));                    // FileName           ?
                            tree.Write(zero);                                                // 00                 1
                            tree.Write(crc);                                                 // CheckSum           4
                            tree.Write(preload_bytes);                                       // PreloadBytes       2
                            tree.Write(archive_index);                                       // ArchiveIndex       2
                            tree.Write(lookup_offset);                                       // EntryOffset        4
                            tree.Write(data_length);                                         // EntryLength        4
                            tree.Write(terminator);                                          // Terminator         2
                            if (unique)
                            {
                                data.Write(data_bytes);                                      // DataBytes written
                                data_offset += data_length;                                  // to secondary stream
                            }
                            tree_size += (uint)filename.Length + 19;
                        }
                        tree.Write(zero);                                                    // 00 Next Directory  1
                        tree_size += 1;
                    }
                    tree.Write(zero);                                                        // 00 Next Type       1
                    tree_size += 1;
                }
                tree.Write(zero);                                                            // 00 Tree End        1
                tree_size += 1;
                mtree.Position = 8;                                                          // TreeSize update
                tree.Write(tree_size);
                mtree.Position = 0;                                                          // Tree write
                mtree.CopyTo(fs); // net 4.0
                mdata.Position = 0;                                                          // Data write
                mdata.CopyTo(fs);
            }
            sw.Stop();
            Console.WriteLine(String.Format("--- Written {0} in {1}s", fn, sw.Elapsed.TotalSeconds));
        }

        public void AddEntry(string dir, string name, string ext, byte[] data)
        {
            if (Entries == null)
                Entries = new Dictionary<string,List<PackageEntry>>();

            if (!Entries.Keys.Contains(ext))
                Entries.Add(ext, new List<PackageEntry>());

            var found = Entries[ext].Find(_ => _.DirectoryName == dir && _.FileName == name);

            if (found == null)
            {
                Entries[ext].Add(new PackageEntry {
                  FileName = name, DirectoryName = dir, TypeName = ext,
                  CRC32 = 0, SmallData = data, ArchiveIndex = 0, Offset = 0, Length = 0
                });
            }
            else
            {
                found.Length = 0;
                found.SmallData = data;
            }
        }

        public void AddEntry(string fullpath, byte[] data)
        {
            var path = fullpath.Replace('\\', '/');
            var s = path.LastIndexOf("/");
            var dir = (s == -1) ? "" : path.Substring(0, s);
            var file = path.Substring(s + 1);
            s = file.LastIndexOf('.');
            var ext = (s == -1) ? " " : file.Substring(s + 1);
            var name = (s == -1) ? file : file.Substring(0, s);

            if (Entries == null)
                Entries = new Dictionary<string,List<PackageEntry>>();

            if (!Entries.Keys.Contains(ext))
                Entries.Add(ext, new List<PackageEntry>());

            var found = Entries[ext].Find(_ => _.DirectoryName == dir && _.FileName == name);

            if (found == null)
            {
                Entries[ext].Add(new PackageEntry {
                  FileName = name, DirectoryName = dir, TypeName = ext,
                  CRC32 = 0, SmallData = data, ArchiveIndex = 0, Offset = 0, Length = 0
                });
            }
            else
            {
                found.Length = 0;
                found.SmallData = data;
            }
        }

        public void AddFolder(string inputdir)
        {
            // include pak01_dir subfolder (if it exists) for manual overrides when modding
            if (!Directory.Exists(inputdir))
                return;

            var paths = new List<string>();
            paths.AddRange(Directory.GetFiles(inputdir, "*.*", SearchOption.AllDirectories));

            if (paths.Count == 0)
                return;

            Console.WriteLine("--- Adding files in \"{0}\"", inputdir);

            var excluded = new List<string>() { "zip", "reg", "rar", "msi", "exe", "dll", "com", "cmd", "bat", "vbs" };
            var iso = Encoding.GetEncoding("ISO-8859-1");
            var utf = Encoding.UTF8;

            foreach (var path in paths)
            {
                byte[] latin = Encoding.Convert(utf, iso, utf.GetBytes(path.Substring(inputdir.Length + 1)));
                string root = iso.GetString(latin).ToLower();

                var ext = Path.GetExtension(root).TrimStart('.');

                if (excluded.Contains(ext))
                    continue; // ERROR illegal extension!

                if (ext == "")
                    ext = " "; // WARNING missing extension

                var name = Path.GetFileNameWithoutExtension(root);

                if (name == "")
                    name = " "; // WARNING missing filename

                var dir = Path.GetDirectoryName(root).Replace('\\', '/');

                if (dir == "")
                    dir = " "; // WARNING missing directoryname

                AddEntry(dir, name, ext, File.ReadAllBytes(path));
            }
        }

        public void Filter(string types, string paths = null, string names = null)
        {
            var fTypes = String.IsNullOrEmpty(types) ? new List<string>() : types.Split(',').Select(_ => _.Trim()).ToList();
            var fPaths = String.IsNullOrEmpty(paths) ? new List<string>() : paths.Split(',').Select(_ => _.Trim()).ToList();
            var fNames = String.IsNullOrEmpty(names) ? new List<string>() : names.Split(',').Select(_ => _.Trim()).ToList();

            foreach (string etype in Entries.Keys.ToList())
            {
                if (fTypes.Count > 0)
                {
                    if (!fTypes.Contains(etype))
                    {
                        Entries.Remove(etype);
                        continue;
                    }
                }

                if (fPaths.Count > 0)
                    Entries[etype].RemoveAll(_ => !fPaths.Exists(_.DirectoryName.StartsWith));

                if (fNames.Count > 0)
                    Entries[etype].RemoveAll(_ => !fNames.Exists(_.FileName.Equals));
            }
        }
    }
}

namespace SteamKit.KeyValue
{
    /*
       VPKMOD Copyright (c) 2019 AveYo
       Extending KeyValue library by SteamRE Team

       LGPL License

       This library is free software; you can redistribute it and/or modify it under
       the terms of the GNU Lesser General Public License as published by the Free
       Software Foundation; version 2.1 of the License.

       This library is distributed in the hope that it will be useful, but WITHOUT
       ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
       FOR A PARTICULAR PURPOSE.

       See the GNU Lesser General Public License for more details.
    */

    public class KVTextReader : StreamReader
    {
        public static Dictionary<char,char> escapedMapping = new Dictionary<char,char>
        {
            { '\\', '\\' }, { 'n', '\n' }, { 'r', '\r' }, //{ 't', '\t' },
        };

        public int lineNumber { get; private set; }

        public KVTextReader(KV keyvalue, Stream input) : base(input)
        {
            bool wasQuoted;
            bool wasConditional;

            lineNumber = 1;
            KV currentKey = keyvalue;

            do
            {
                var s = ReadToken(out wasQuoted, out wasConditional);

                if (String.IsNullOrEmpty(s))
                    break;

                if (currentKey == null)
                {
                    currentKey = new KV(s);
                }
                else
                {
                    currentKey.k = s;
                }

                s = ReadToken(out wasQuoted, out wasConditional);

                if (wasConditional)
                {
                  //currentKey.condition = s;

                    // Now get the '{'
                    s = ReadToken(out wasQuoted, out wasConditional);
                }

                if (s != null && s.StartsWith("{") && !wasQuoted)
                {
                    // header is valid so load the file
                    currentKey.RecursiveLoadFromBuffer(this);
                }
                else
                {
                    throw new FormatException("KV: missing {");
                }
                currentKey = null;
            }
            while (!EndOfStream);
        }

        public void EatWhiteSpace()
        {
            while (!EndOfStream)
            {
                if (!Char.IsWhiteSpace((char)Peek()))
                    break;
                if ((char)Read() == '\n')
                    lineNumber++;
            }
        }

        public bool EatCPPComment()
        {
            if (!EndOfStream)
            {
                char next = (char)Peek();
                if (next == '/')
                {
                    ReadLine();
                    return true;
                }
                return false;
            }
            return false;
        }

        public string ReadToken(out bool wasQuoted, out bool wasConditional)
        {
            wasQuoted = false;
            wasConditional = false;

            while (true)
            {
                EatWhiteSpace();

                if (EndOfStream)
                    return null;

                if (!EatCPPComment())
                    break;
            }

            if (EndOfStream)
                return null;

            char next = (char)Peek();

            if (next == '"')
            {
                wasQuoted = true;

                // "
                Read();

                var sb = new StringBuilder();
                while (!EndOfStream)
                {
                    if (Peek() == '\\')
                    {
                        Read();

                        char escapedChar = (char)Read();
                        char replacedChar;

                        if (escapedMapping.TryGetValue(escapedChar, out replacedChar))
                            sb.Append(replacedChar);
                        else
                            sb.Append(escapedChar);

                        continue;
                    }

                    if (Peek() == '"')
                        break;

                    sb.Append((char)Read());
                }

                // "
                Read();

                return sb.ToString();
            }

            if (next == '{' || next == '}')
            {
                Read();
                return next.ToString();
            }

            bool bConditionalStart = false;
            int count = 0;
            var ret = new StringBuilder();
            while (!EndOfStream)
            {
                next = (char)Peek();

                if (next == '"' || next == '{' || next == '}')
                    break;

                if (next == '[')
                    bConditionalStart = true;

                if (next == ']' && bConditionalStart)
                    wasConditional = true;

                if (Char.IsWhiteSpace(next))
                    break;

                if (count < 1023)
                {
                    ret.Append(next);
                }
                else
                {
                    throw new FormatException("KV: ReadToken overflow");
                }
                Read();
            }
            return ret.ToString();
        }
    }

    public class KV
    {
        public KV(string name = null, string value = null, int index = 0)
        {
            this.k = name; this.v = value; this.i = index; this.items = new List<KV>();
        }

        public string k { get; set; }
        public string v { get; set; }
        public int i { get; private set; }
        private static readonly KV empty = new KV();
        private static readonly KV error = new KV();
        public List<KV> items { get; private set; }
        public List<KV>.Enumerator GetEnumerator() { return this.items.GetEnumerator(); }

        public KV this[string key, int index = 0]
        {
            // index can be negative to return duplicates from the end ( -1 for last, -2 for second to last ... )
            get
            {
                if (key == null || this.k == null)
                {
                    return error; // prevent garbage values for non-existing key or index
                }
                else if (this.items.Count == 0)
                {
                    return empty;
                }
                else if (index == 0)
                {
                    return this.items.Find(_ => key.Equals(_.k, StringComparison.OrdinalIgnoreCase)) ?? empty;
                }
                else
                {
                    var duplicatekey = Enumerable.Range(0, this.items.Count)
                        .Where(_ => key.Equals(this.items[_].k, StringComparison.OrdinalIgnoreCase));
                    var matches = duplicatekey.Count();
                    if (matches == 0 || index >= matches || index + matches < 1)
                        return empty;

                    if (index < 0)
                        index += matches;

                    var entry = this.items[duplicatekey.ElementAt(index)];
                    entry.i = index;
                    return entry;
                }
            }

            set
            {
                value.k = key;

                if (key == null)
                {
                    return;
                }
                else if (this.items.Count == 0)
                {
                    this.items.Add(value);
                }
                else if (index == 0)
                {
                    var firstindex = this.items.FindIndex(_ => key.Equals(_.k, StringComparison.OrdinalIgnoreCase));
                    if (firstindex == -1)
                        this.items.Add(value);
                    else
                        this.items[firstindex] = value;
                }
                else
                {
                    var duplicateindex = Enumerable.Range(0, this.items.Count)
                        .Where(_ => key.Equals(this.items[_].k, StringComparison.OrdinalIgnoreCase));
                    var matches = duplicateindex.Count();
                    if (matches == 0 || index >= matches || index + matches < 1)
                        this.items.Add(value);
                    else
                        this.items[duplicateindex.ElementAt(index < 0 ? index + matches : index)] = value;
                }
            }
        }

        public bool notfound { get { return this.k == null; } }
        public bool found { get { return this.k != null; } }
        public int count { get { return this.items.Count; } }
        public int kint { get { int x; return !int.TryParse(this.k, out x) ? -1 : x; } }
        public int vint { get { int x; return !int.TryParse(this.v, out x) ? -1 : x; } }
        public bool vbool { get { int x; return !int.TryParse(this.v, out x) ? false : x != 0; } }
        public List<string> vlist { get { return (this.v ?? "").Split(',').Select(_ => _.Trim()).ToList(); } }
        public KV first { get { return this.items.Count == 0 ? empty : this.items[0]; } }
        public KV last { get { return this.items.Count == 0 ? empty : this.items[this.items.Count - 1]; } }

        public List<KV> having(string key1, string val1 = null)
        {
            var iCase = StringComparison.OrdinalIgnoreCase;

            if (key1 != null && val1 != null)
                return this.items.FindAll(_ => _.items.Exists(__ => key1.Equals(__.k, iCase) && val1.Equals(__.v, iCase)));
            else if (val1 == null)
                return this.items.FindAll(_ => _.items.Exists(__ => key1.Equals(__.k, iCase)));
            else if (key1 == null)
                return this.items.FindAll(_ => _.items.Exists(__ => val1.Equals(__.v, iCase)));
            else
                return new List<KV>();
        }

        public List<KV> having(string key1, string val1, string key2, string val2 = null)
        {
            var iCase = StringComparison.OrdinalIgnoreCase;

            if (key1 != null && val1 != null && key2 != null && val2 != null)
                return this.items.FindAll(_ => _.items.Exists(__ => key1.Equals(__.k, iCase) && val1.Equals(__.v, iCase)) &&
                                            _.items.Exists(__ => key2.Equals(__.k, iCase) && val2.Equals(__.v, iCase)));
            else if (key1 != null && val1 == null && key2 != null && val2 == null)
                return this.items.FindAll(_ => _.items.Exists(__ => key1.Equals(__.k, iCase)) &&
                                            _.items.Exists(__ => key2.Equals(__.k, iCase)));
            else if (key1 == null && val1 != null && key2 == null && val2 != null)
                return this.items.FindAll(_ => _.items.Exists(__ => val1.Equals(__.v, iCase)) &&
                                            _.items.Exists(__ => val2.Equals(__.v, iCase)));
            else
                return new List<KV>();
        }

        public KV clone(KV keyval)
        {
            var cloned = new KV();
            cloned.items.Add(keyval);

            return cloned.items[0];
        }

        public KV add(string key)
        {
            if (this[key] == empty)
                this.items.Add(new KV(key));

            return this[key];
        }

        public void add(string key, string val)
        {
            if (this[key] == empty)
                this.items.Add(new KV(key, val));
            else
                this[key].v = val;
        }

        public void add(string key, List<string> vals)
        {
            var joined = String.Join(",", vals);
            if (this[key] == empty)
                this.items.Add(new KV(key, joined));
            else
                this[key].v = joined;
        }

        public void add(List<string> keys)
        {
            foreach (string m in keys)
            {
                string key = m.Trim();
                if (this[key] == empty)
                    this.items.Add(new KV(key, ""));
            }
        }

        public void add(KV keyval)
        {
            var firstindex = this.items.FindIndex(_ => keyval.k.Equals(_.k, StringComparison.OrdinalIgnoreCase));

            if (firstindex == -1)
                this.items.Add(keyval);
            else
                this.items[firstindex] = keyval;
        }

        public void remove(string key)
        {
            this.items.RemoveAll(_ => key.Equals(_.k, StringComparison.OrdinalIgnoreCase));
        }

        public void remove(string key, int index)
        {
            this.items.Remove(this[key, index]);
        }

        public void remove(List<string> keys)
        {
            foreach (string key in keys)
            {
                this.items.RemoveAll(_ => key.Trim().Equals(_.k, StringComparison.OrdinalIgnoreCase));
            }
        }

        public void remove(KV keyval)
        {
            if (keyval.k != null)
                this.items.RemoveAll(_ => keyval.k.Equals(_.k, StringComparison.OrdinalIgnoreCase));
        }

        public override string ToString()
        {
            if (this.k == null)
                return "";
            var s = String.Format("{0}\t{1}", this.k, this.v);
            foreach (var entry in this.items)
            {
                s = String.Format("{0}\n  {1}\t{2}", s, entry.k, entry.v ?? "{..}");
            }
            return s;
        }

        public static KV LoadFromFile(string path)
        {
            if (File.Exists(path) == false)
                return null;

            try
            {
                using (var input = File.Open(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
                {
                    var keyvalue = new KV();

                    if (keyvalue.ReadAsText(input) == false)
                        return null;

                    return keyvalue;
                }
            }
            catch (Exception e)
            {
                Console.Error.WriteLine("<Error> " + e.Message);
                return null;
            }
        }

        public static KV LoadFromString(string input)
        {
            if (input == null)
                throw new ArgumentNullException("KV: input");

            byte[] bytes = Encoding.UTF8.GetBytes(input);

            using (MemoryStream stream = new MemoryStream(bytes))
            {
                var keyvalue = new KV();

                try
                {
                    if (keyvalue.ReadAsText(stream) == false)
                        return null;

                    return keyvalue;
                }
                catch (Exception e)
                {
                    Console.Error.WriteLine("<Error> " + e.Message);
                    return null;
                }
            }
        }

        public static KV LoadFromBytes(byte[] input)
        {
            if (input == null)
                throw new ArgumentNullException("KV: input");

            using (MemoryStream stream = new MemoryStream(input))
            {
                var keyvalue = new KV();

                try
                {
                    if (keyvalue.ReadAsText(stream) == false)
                        return null;

                    return keyvalue;
                }
                catch (Exception e)
                {
                    Console.Error.WriteLine("<Error> " + e.Message);
                    return null;
                }
            }
        }

        public bool ReadAsText(Stream input)
        {
            if (input == null)
                throw new ArgumentNullException("KV: input");

            this.items = new List<KV>();

            using (var unused = new KVTextReader(this, input))
            {
            }

            return true;
        }

        public bool ReadFileAsText(string filename)
        {
            using (FileStream fs = new FileStream(filename, FileMode.Open))
            {
                return ReadAsText(fs);
            }
        }

        public void RecursiveLoadFromBuffer(KVTextReader kvr)
        {
            bool wasQuoted = false;
            bool wasConditional = false;
          //string testConditional = null;
          //var seen = new Dictionary<string,int>();

            while (true)
            {
                // bool bAccepted = true;

                // get the key name / reuse previous iteration if it was not a Conditional but lame multiple kv's on a single line
                /*
                var name = testConditional;
                if (testConditional == null)
                    name = kvr.ReadToken(out wasQuoted, out wasConditional);
                */
                var name = kvr.ReadToken(out wasQuoted, out wasConditional);

                if (String.IsNullOrEmpty(name))
                    throw new FormatException("KV: EOF or empty keyname");

                if (name.StartsWith("}") && !wasQuoted) // top level closed, stop reading
                    break;

                KV dat = new KV(name);

                /*
                // increment index for duplicate key name
                if (seen.ContainsKey(name))
                    seen[name]++;
                else
                    seen.Add(name, 0);

                dat.i = seen[name];
                */

                this.items.Add(dat);

                // get the value
                var value = kvr.ReadToken(out wasQuoted, out wasConditional);

                if (wasConditional && value != null)
                {
                    // bAccepted = ( value == "[$WIN32]" );
                  //dat.condition = value;
                    value = kvr.ReadToken(out wasQuoted, out wasConditional);
                }

                if (value == null)
                    throw new FormatException("KV:  NULL key ('" + value + "' on line " + kvr.lineNumber + ")");

                if (value.StartsWith("}") && !wasQuoted)
                    throw new FormatException("KV:  } in key ('" + value + "' on line " + kvr.lineNumber + ")");

                if (value.StartsWith("{") && !wasQuoted)
                {
                    dat.RecursiveLoadFromBuffer(kvr);
                }
                else
                {
                    if (wasConditional)
                        throw new FormatException(
                          "KV:  conditional between key and value ('" + value + "' on line " + kvr.lineNumber + ")");

                    dat.v = value;
                    // Conditionals matter! :D
                }

                // Conditional should come after key and value
                /*
                testConditional = kvr.ReadToken(out wasQuoted, out wasConditional);
                if (testConditional.StartsWith("}"))
                {
                    break;
                }
                else if (wasConditional)
                {
                    dat.condition = testConditional;
                    testConditional = null;
                }
                */
            }
        }

        public void SaveToFile(string path)
        {
            using (var f = File.Create(path))
            {
                SaveToStream(f);
            }
        }

        public void SaveToStream(Stream stream)
        {
            if (stream == null)
                throw new ArgumentNullException("KV: stream");

            RecursiveSaveTextToFile(stream);
        }

        public void RecursiveSaveTextToFile(Stream stream, int indentLevel = 0)
        {
            // write header
            WriteIndents(stream, indentLevel);
            WriteString(stream, k, true);
          //WriteString(stream, condition != null ? "\t" + condition : "");
            WriteString(stream, "\n");
            WriteIndents(stream, indentLevel);
            WriteString(stream, "{\n");

            // loop through all our keys writing them to disk
            foreach (KV child in items)
            {
                if (child.v == null)
                {
                    child.RecursiveSaveTextToFile(stream, indentLevel + 1);
                }
                else
                {
                    WriteIndents(stream, indentLevel + 1);
                    WriteString(stream, child.k, true);
                    WriteString(stream, "\t\t");
                    WriteString(stream, EscapeText(child.v), true);
                  //WriteString(stream, child.condition != null ? "\t" + child.condition : "");
                    WriteString(stream, "\n");
                }
            }

            WriteIndents(stream, indentLevel);
            WriteString(stream, "}\n");
        }

        static string EscapeText(string value)
        {
            foreach (var kvp in KVTextReader.escapedMapping)
            {
                var textToReplace = new string(kvp.Value, 1);
                var escapedReplacement = @"\" + kvp.Key;
                value = value.Replace(textToReplace, escapedReplacement);
            }

            return value;
        }

        void WriteIndents(Stream stream, int indentLevel)
        {
            WriteString(stream, new string('\t', indentLevel));
        }

        static void WriteString(Stream stream, string str, bool quote = false)
        {
            byte[] bytes = Encoding.UTF8.GetBytes((quote ? "\"" : "") + str.Replace("\"", "\\\"") + (quote ? "\"" : ""));
            stream.Write(bytes, 0, bytes.Length);
        }
    }
}

namespace VPKMOD
{
    // VPKMOD v2.0 retains the useful v1.x legacy code based on Decompiler by SteamDatabase
    // so it continues to be a generic tool to list, extract, create, filter and in-memory mod VPKs
    // The main focus however is on supporting No-Bling DOTA mod builder functionality

    public class Options
    {
        public string Input { get; set; }
        public bool Recursive { get; set; }
        public string Output { get; set; }
        public bool OutputVPKDir { get; set; }
        public bool CachedManifest { get; set; }
        public bool VerifyVPKChecksums { get; set; }
        public List<string> ExtFilter { get; set; }
        public List<string> PathFilter { get; set; }
        public string FilterList { get; set; }
        public string ModList { get; set; }
        public bool Silent { get; set; }
        public bool Help { get; set; }
        public bool NoBlingDOTABuilder { get; set; }
        public bool MONO { get { int p = (int)Environment.OSVersion.Platform; return ((p == 4) || (p == 6) || (p == 128)); } }
        internal IDictionary<string,List<string>> Parsed { get; private set; }

        public Options(string[] cmd = null)
        {
            Parsed = new Dictionary<string,List<string>>(); Parse(cmd);
        }

        internal bool Find(string key, bool novalue = false)
        {
            if (Parsed.ContainsKey(key))
            {
                if (novalue || Parsed[key].Count != 0) return true;
                Console.Error.WriteLine("VPKMOD ERROR! Missing argument for: -{0}", key);
            }
            return false;
        }

        internal void Parse(string[] cmd)
        {
            var key = ""; List<string> values = new List<string>();
            foreach (string item in cmd)
            {
                if (item[0] == '-') { if (key != "") Parsed[key] = values; key = item.Substring(1); values = new List<string>(); }
                else if (key == "") { Parsed[item] = new List<string>(); }
                else { values = new List<string>(item.Split(',')); }
            }
            if (key != "") Parsed[key] = values;

            Input              = Find("i") ? Parsed["i"][0] : "";
            Recursive          = Find("r", true);
            Output             = Find("o") ? Parsed["o"][0] : "";
            CachedManifest     = Find("c", true);
            OutputVPKDir       = Find("d", true);
            VerifyVPKChecksums = Find("v", true);
            ExtFilter          = Find("e") ? Parsed["e"] : new List<string>();
            PathFilter         = Find("p") ? Parsed["p"] : new List<string>();
            FilterList         = Find("l") ? Parsed["l"][0] : "";
            ModList            = Find("m") ? Parsed["m"][0] : "";
            NoBlingDOTABuilder = Find("b", true);
            Silent             = Find("s", true);
            Help               = Find("h", true) || cmd.Length == 0;

            if (Silent == false && NoBlingDOTABuilder == false)
            {
                Console.ForegroundColor = ConsoleColor.Black; Console.BackgroundColor = ConsoleColor.Cyan;
                Console.Write(" VPKMOD v2.0 "); Console.ResetColor(); Console.WriteLine("  AveYo / SteamDatabase");
            }
            if (Help)
            {
                Console.WriteLine(" -i input      Directory to create new VPK from, or File to extract VPK from");
                Console.WriteLine(" -o output     File to create VPK to, or Directory to extract VPK to");
                Console.WriteLine(" -r            Recursively include all files in Directory");
                Console.WriteLine(" -c            Cached VPK manifest: only changed files get written to disk");
                Console.WriteLine(" -d            Write VPK directory of files and their CRC to console");
                Console.WriteLine(" -v            Verify checksums and signatures: only for VPK version 2");
                Console.WriteLine(" -e txt,vjs_c  Extension(s) filter: only include these file extensions");
                Console.WriteLine(" -p cfg/,dev/  Path(s) filter: only include files from these paths");
                Console.WriteLine(" -l list.txt   List file to import fullpath filters from;");
                Console.WriteLine("               if -e or -p are also used, export current filters instead");
                Console.WriteLine(" -m mod.txt    Mod?Src entries for legacy in-memory unpak-rename-pak;");
                Console.WriteLine("               if Src = \".nix\" set Mod file content to 0-byte");
                Console.WriteLine(" -b            The refreshed No-Bling DOTA mod builder");
                Console.WriteLine(" -s            Silent");
                Console.WriteLine(" -h            This help screen");
                Console.ReadKey(); Environment.Exit(0);
            }
        }
    }

    public class Choices
    {
        public static List<string> Dialog ( string all_cb, string sel_cb, string def_cb,
            string title, byte sz = 14, string fc = "Snow", string bc = "Navy", int w = 0, int h = 0 )
        {
            var all = all_cb.Split(',').ToList(); var sel = sel_cb.Split(',').ToList(); var def = def_cb.Split(',').ToList();
            var selection = new List<string>(); var cb = new List<CheckBox>(); var bn = new List<Button>();
            using (Form f = new Form())
            {
                f.Text = title; f.Font = new Font(FontFamily.GenericSerif, sz); f.ForeColor = Color.FromName(fc);
                f.BackColor = Color.FromName(bc); f.MinimumSize = new Size(w, h); f.TopMost = true; f.MaximizeBox = false;
                f.StartPosition = (FormStartPosition)1; f.AutoSize = false; f.SuspendLayout();
                int i = 0, j = 0, k = all.Count + 3, maxchars = Math.Max(all.Max(_ => _.Length) + 2, 24); all.Reverse();
                all.ForEach(_ => {  //Options
                    var c = new CheckBox() {
                        Text = _, Font = f.Font, Name = "c" + i, TabIndex = k--, AutoSize = true,  Dock = (DockStyle)1,
                        FlatStyle = (FlatStyle)0, Appearance = (Appearance)0, TextAlign = (ContentAlignment)32 // bugged on MONO
                    }; c.FlatAppearance.BorderSize = 0; c.Click += delegate { };
                    f.Controls.Add(c); cb.Add(c); i++;
                });
                k = 0;
                var p = new FlowLayoutPanel() {WrapContents = false, AutoSize = true, Dock = (DockStyle)2 }; p.SuspendLayout(); //Bottom Row
                "Default OK Cancel".Split().ToList().ForEach(_ => {
                    var b = new Button() {
                        Text = _, Font = f.Font, Name = "b" + j, TabIndex = k++, AutoSize = true, Dock = (DockStyle)2,
                        FlatStyle = (FlatStyle)0, DialogResult = (DialogResult)j
                    }; b.FlatAppearance.BorderSize = 2; p.Controls.Add(b);  bn.Add(b); j++;
                });
                bn[0].Click += delegate {cb.ForEach(_ =>{_.Checked = def.Any(_.Text.Contains) ? true : false; InvertCheck(_);});};
                bn[1].Click += delegate { f.Close(); f.Dispose(); };
                f.SizeChanged += delegate {
                    int sw = f.Width - 30; bn.ForEach(_ => {sw -= _.Width;}); sw /= 2; p.Padding = new Padding(sw, 0, sw, 0);
                    for (int u = 0; u < all.Count; u++) {
                        var len = all[u].Length; cb[u].Padding = new Padding(sw, 0, sw, 0); if (maxchars > 80) continue;
                        cb[u].Text = all[u].PadLeft(((maxchars - len) / 2) + len).PadRight(maxchars); // MONO TextAlign workaround
                    }
                };
                f.Load += delegate {
                    cb.ForEach(_ => { _.Checked = sel.Any(_.Text.Contains) ? true : false; InvertCheck(_); });
                    f.MinimumSize = new Size(Math.Max(cb.Max(_ => _.Width), f.Width), cb[0].Height * (all.Count + 3)); f.Width++;
                    f.ActiveControl = bn[1]; f.Activate();
                };
                f.Controls.Add(p); p.ResumeLayout(true); f.ResumeLayout(true); var result = f.ShowDialog();
                if (result == (DialogResult)1) { cb.ForEach(_ => {if (_.Checked == true) selection.Add(_.Text.Trim());}); }
            }
            selection.Reverse(); return selection;
        }
        internal static void InvertCheck(CheckBox c)
        {
            var b = c.Parent.BackColor; var f = c.Parent.ForeColor; c.ForeColor = c.Checked ? b:f; c.BackColor = c.Checked ? f:b;
        }
    }

    class Program
    {
        private static Options Options;
        private static readonly object ConsoleWriterLock = new object();
        private static Dictionary<string,uint> OldPakManifest = new Dictionary<string,uint>();
        private static Dictionary<string,Dictionary<string,bool>> ModSrc = new Dictionary<string,Dictionary<string,bool>>();
        private static Dictionary<string,string> SrcMod = new Dictionary<string,string>();
        private static List<string> FileFilter = new List<string>();
        private static List<string> ExtFilter = new List<string>();
        private static bool ExportFilter = false;

        private static void LegacyReadVPK(string path)
        {
            Echo(String.Format("--- Listing files in package \"{0}\"", path), 1, ConsoleColor.Green);
            var sw = Stopwatch.StartNew();
            var package = new Package();
            try
            {
                package.Read(path);
            }
            catch (Exception e)
            {
                Echo(e.ToString(), 1, ConsoleColor.Yellow);
            }

            if (Options.VerifyVPKChecksums && package.Version == 2)
            {
                try
                {
                    package.VerifyHashes();
                    Console.WriteLine("VPK verification succeeded");
                }
                catch (Exception)
                {
                    Echo("Failed to verify checksums and signature of given VPK:", 1, ConsoleColor.Red);
                }
                return;
            }

            if (!String.IsNullOrEmpty(Options.Output) && !Options.OutputVPKDir)
            {
                //Console.WriteLine("--- Reading VPK files...");
                var manifestPath = String.Concat(path, ".manifest.txt");
                if (Options.CachedManifest && File.Exists(manifestPath))
                {
                    var file = new StreamReader(manifestPath);
                    string line;
                    while ((line = file.ReadLine()) != null)
                    {
                        var split = line.Split(new[] { ' ' }, 2);
                        if (split.Length == 2) OldPakManifest.Add(split[1], uint.Parse(split[0]));
                    }
                    file.Close();
                }

                foreach (var etype in package.Entries)
                {
                    if (ExtFilter.Count > 0 && !ExtFilter.Contains(etype.Key)) continue;
                    else if (Options.ExtFilter.Count > 0 && !Options.ExtFilter.Contains(etype.Key)) continue;

                    LegacyDumpVPK(package, etype.Key);
                }

                if (Options.CachedManifest)
                {
                    using (var file = new StreamWriter(manifestPath))
                    {
                        foreach (var hash in OldPakManifest)
                        {
                            if (package.FindEntry(hash.Key) == null) Console.WriteLine("\t{0} no longer exists in VPK", hash.Key);
                            file.WriteLine("{0} {1}", hash.Value, hash.Key);
                        }
                    }
                }
            }

            if (Options.OutputVPKDir)
            {
                foreach (var etype in package.Entries)
                {
                    foreach (var entry in etype.Value)
                    {
                        Console.WriteLine(entry);
                    }
                }
            }

            if (ExportFilter)
            {
                using (var filter = new StreamWriter(Options.FilterList))
                {
                    foreach (var etype in package.Entries)
                    {
                        if (Options.ExtFilter.Count > 0 && !Options.ExtFilter.Contains(etype.Key)) continue;

                        foreach (var entry in etype.Value)
                        {
                            var ListPath = SlashPath(entry.GetFullPath());
                            if (Options.PathFilter.Count > 0)
                            {
                                var found = false;
                                foreach (string pathfilter in Options.PathFilter)
                                {
                                    if (ListPath.StartsWith(pathfilter, StringComparison.OrdinalIgnoreCase)) found = true;
                                }
                                if (!found) continue;
                            }
                            filter.WriteLine(ListPath);
                            if (!Options.Silent) Console.WriteLine(ListPath);
                        }
                    }
                }
            }

            sw.Stop();

            Echo(String.Format("--- Processed in {0}s", sw.Elapsed.TotalSeconds), 1, ConsoleColor.Cyan);
        }

        private static int LegacyWriteVPK(List<string> paths, bool modding)
        {
            if (paths.Count == 0) return 0;
            var inputdir = Options.Input;
            var sw = Stopwatch.StartNew();
            var package = new Package();
            var pak01_dir = new Package();

            Echo(modding ? "--- Modding... " : "--- Paking... ", 0, ConsoleColor.Green);
            Echo(paths.Count);

            if (modding)
            {
                try { package.Read(Options.Input); } catch (Exception e) { Echo(e.ToString(), 1, ConsoleColor.Yellow); }

                foreach (var etype in package.Entries)
                {
                    if (ExtFilter.Count > 0 && !ExtFilter.Contains(etype.Key)) continue;
                    else if (Options.ExtFilter.Count > 0 && !Options.ExtFilter.Contains(etype.Key)) continue;

                    var entries = package.Entries[etype.Key];

                    foreach (var entry in entries)
                    {
                        var filePath = String.Format("{0}.{1}", entry.FileName, entry.TypeName);
                        if (entry.DirectoryName.Length > 0) filePath = Path.Combine(entry.DirectoryName, filePath);
                        filePath = SlashPath(filePath);

                        bool found = false;
                        if (FileFilter.Count > 0)
                        {
                            foreach (string filter in FileFilter)
                            {
                                if (filePath == filter) found = true; // StartsWith
                            }
                            if (!found) continue;
                        }
                        else if (Options.PathFilter.Count > 0)
                        {
                            foreach (string filter in Options.PathFilter)
                            {
                                if (filePath.StartsWith(filter, StringComparison.OrdinalIgnoreCase)) found = true;
                            }
                            if (!found) continue;
                        }

                        var ext = entry.TypeName;
                        if (ext == "")
                        {
                            ext = " ";
                            if (!Options.Silent) Echo("  missing extension!", 1, ConsoleColor.Red);
                            //continue;
                        }
                        var file = entry.FileName; //Path.GetFileNameWithoutExtension(root);
                        if (file == "")
                        {
                            file = " ";
                            if (!Options.Silent) Echo("  missing name!", 1, ConsoleColor.Red);
                            //continue;
                        }
                        var dir = entry.DirectoryName; //Path.GetDirectoryName(root).Replace('\\', '/');

                        byte[] output;
                        package.ReadEntry(entry, out output);

                        if (ModSrc.ContainsKey(filePath))
                        {
                            if (!Options.Silent) Console.WriteLine("--- Replacing with {0}", filePath);
                            foreach (var m in ModSrc[filePath])
                            {
                                if (!Options.Silent) Console.WriteLine("    {0}", m);
                                filePath = m.Key;
                                ext = Path.GetExtension(m.Key).TrimStart('.');
                                file = Path.GetFileNameWithoutExtension(m.Key);
                                dir = Path.GetDirectoryName(m.Key).Replace('\\', '/');
                                if (dir == "") dir = " ";
                                pak01_dir.AddEntry(dir, file, ext, output);
                            }
                        }
                        else
                        {
                            if (dir == "") dir = " ";
                            pak01_dir.AddEntry(dir, file, ext, output);
                        }
                    }
                }

                // mod size optimization: replace res with zero-byte file if mod?src pair has src=".nix"
                string nix = ".nix";
                if (ModSrc.ContainsKey(nix))
                {
                    if (!Options.Silent) Console.WriteLine("--- Replacing with \".nix\" [ 0-byte data ]");
                    foreach (var m in ModSrc[nix])
                    {
                        if (!Options.Silent) Console.WriteLine("    {0}", m);
                        var ext = Path.GetExtension(m.Key).TrimStart('.');
                        var file = Path.GetFileNameWithoutExtension(m.Key);
                        var dir = Path.GetDirectoryName(m.Key).Replace('\\', '/');
                        if (dir == "") dir = " ";
                        pak01_dir.AddEntry(dir, file, ext, new byte[0]);
                    }
                }
            }

            // include pak01_dir subfolder (if it exists) for manual overrides when modding
            if (Directory.Exists("pak01_dir") && modding)
            {
                if (!Options.Silent) Console.WriteLine("--- Including files in \"pak01_dir\" folder");
                pak01_dir.AddFolder("pak01_dir");
            }

            if (!modding)
            {
                pak01_dir.AddFolder(inputdir);
            }

            pak01_dir.SaveToFile(Options.Output);
            sw.Stop();
            var files = pak01_dir.Entries.Values.Sum(_ => _.Count);
            Echo(String.Format("--- Processed {0} files in {1}s", files, sw.Elapsed.TotalSeconds), 1, ConsoleColor.Cyan);
            return files;
        }

        private static void LegacyDumpVPK(Package package, string ext)
        {
            var entries = package.Entries[ext];

            foreach (var entry in entries)
            {
                var filePath = String.Format("{0}.{1}", entry.FileName, entry.TypeName);
                if (!String.IsNullOrEmpty(entry.DirectoryName)) filePath = Path.Combine(entry.DirectoryName, filePath);
                filePath = SlashPath(filePath);

                bool found = false;
                if (FileFilter.Count > 0)
                {
                    foreach (string filter in FileFilter)
                    {
                        if (filePath.StartsWith(filter, StringComparison.OrdinalIgnoreCase)) found = true;
                    }
                    if (!found) continue;
                }
                else if (Options.PathFilter.Count > 0)
                {
                    foreach (string filter in Options.PathFilter)
                    {
                        if (filePath.StartsWith(filter, StringComparison.OrdinalIgnoreCase)) found = true;
                    }
                    if (!found) continue;
                }

                if (!String.IsNullOrEmpty(Options.Output))
                {
                    uint oldCrc32;
                    if (Options.CachedManifest && OldPakManifest.TryGetValue(filePath, out oldCrc32) && oldCrc32 == entry.CRC32)
                        continue;
                    OldPakManifest[filePath] = entry.CRC32;
                }

                byte[] output;
                package.ReadEntry(entry, out output);

                if (!String.IsNullOrEmpty(Options.Output)) LegacyDumpFile(filePath, output);
            }
        }

        private static void LegacyDumpFile(string path, byte[] data)
        {
            var outputFile = Path.Combine(Options.Output, path);
            Directory.CreateDirectory(Path.GetDirectoryName(outputFile));
            File.WriteAllBytes(outputFile, data);
            if (!Options.Silent) Console.WriteLine("--- Written \"{0}\"", outputFile);
        }

        public static string SlashPath(string path)
        {
            if (path == null) return null;
            else if (path.Length == 1) return path;
            else return String.Join("/", path.Split(new[] {'/', '\\'}, StringSplitOptions.None)).TrimEnd('/');//RemoveEmptyEntries
        }

        public static void Log(params object[] msg)
        {
            if (Options.Silent == false) Console.WriteLine(String.Join(" ", msg));
        }

        public static void Echo(object msg, int newline = 1, ConsoleColor clr = ConsoleColor.Gray)
        {
            lock (ConsoleWriterLock)
            {
                Console.ForegroundColor = clr;
                Console.Write(newline == 1 ? "{0}\n" : "{0}", msg);
                Console.ResetColor();
            }
        }

        public static void Main(string[] args)
        {
            Options = new Options(args);

            if (Options.NoBlingDOTABuilder)
            {
                NoBlingDOTABuilder();
                return;
            }

            // Legacy v1 functions:
            if (String.IsNullOrEmpty(Options.Input))
            {
                Echo("Missing -i input parameter!", 1, ConsoleColor.Red);
                return;
            }
            Options.Input = SlashPath(Path.GetFullPath(Options.Input));

            if (!String.IsNullOrEmpty(Options.Output)) Options.Output = SlashPath(Path.GetFullPath(Options.Output));

            if (!String.IsNullOrEmpty(Options.ModList))
            {
                Options.ModList = SlashPath(Path.GetFullPath(Options.ModList));
                if (File.Exists(Options.ModList))
                {
                    var file = new StreamReader(Options.ModList);
                    string line, ext, mod, src;
                    Dictionary<string,bool> m = new Dictionary<string,bool>();
                    while ((line = file.ReadLine()) != null)
                    {
                        var split = line.Split(new[] { '?' }, 2);
                        if (split.Length == 2)
                        {
                            mod = SlashPath(split[0]);
                            src = SlashPath(split[1]);
                            FileFilter.Add(src);
                            ext = Path.GetExtension(src);
                            if (ext.Length > 1) ExtFilter.Add(ext.Substring(1));
                            SrcMod[src] = mod;
                            if (!ModSrc.ContainsKey(src)) ModSrc.Add(src, new Dictionary<string,bool> { { mod, false } });
                            else ModSrc[src].Add(mod, false);
                        }
                    }
                    file.Close();
                }
            }
            else if (!String.IsNullOrEmpty(Options.FilterList))
            {
                Options.FilterList = SlashPath(Path.GetFullPath(Options.FilterList));
                if (File.Exists(Options.FilterList))
                {
                    var file = new StreamReader(Options.FilterList);
                    string line, ext;
                    while ((line = file.ReadLine()) != null)
                    {
                        FileFilter.Add(SlashPath(line));
                        ext = Path.GetExtension(line);
                        if (ext.Length > 1) ExtFilter.Add(ext.Substring(1));
                    }
                    file.Close();
                }

                if (Options.PathFilter.Count > 0 || Options.ExtFilter.Count > 0) ExportFilter = true;
            }

            if (Options.PathFilter.Count > 0) Options.PathFilter = Options.PathFilter.ConvertAll(SlashPath);

            var paths = new List<string>();

            if (Directory.Exists(Options.Input))
            {
                if (Path.GetExtension(Options.Output).ToLower() != ".vpk")
                {
                    Echo(String.Format("Input \"{0}\" is a directory while Output \"{1}\" is not a VPK.",
                      Options.Input, Options.Output), 1, ConsoleColor.Red);
                    return;
                }
                paths.AddRange(Directory.GetFiles(Options.Input, "*.*",
                  Options.Recursive ? SearchOption.AllDirectories : SearchOption.TopDirectoryOnly));
                if (paths.Count == 0)
                {
                    Echo(String.Format("No such file \"{0}\" or dir is empty. Did you mean to include -r (recursive) parameter?",
                        Options.Input), 1, ConsoleColor.Red);
                    return;
                }
                LegacyWriteVPK(paths, false); // pak directory into output.vpk
            }
            else if (File.Exists(Options.Input))
            {
                if (Path.GetExtension(Options.Input).ToLower() != ".vpk")
                {
                    Echo(String.Format("Input \"{0}\" is not a VPK.", Options.Input), 1, ConsoleColor.Red);
                    return;
                }
                paths.Add(Options.Input);

                if (Path.GetExtension(Options.Output).ToLower() != ".vpk")
                    LegacyReadVPK(Options.Input); // unpak input.vpk into output dir
                else
                    LegacyWriteVPK(paths, true); // mod input.vpk into output.vpk
            }
        }

        public static void HowTo()
        {
            lock (ConsoleWriterLock)
            {
                Console.WriteLine(); Console.ForegroundColor = ConsoleColor.Black; Console.BackgroundColor = ConsoleColor.Cyan;
                Console.Write(" To use No-Bling DOTA mod, add launch option: "); Console.ResetColor();
                Console.WriteLine(" -tempcontent");
            }
        }

        public static void Start()
        {
            var logo = Assembly.GetExecutingAssembly().GetCustomAttributes(typeof(AssemblyDescriptionAttribute), false)
                .OfType<AssemblyDescriptionAttribute>().FirstOrDefault().Description.Split(new[]{"\r\n", "\n"}, 0);
            var version = Assembly.GetExecutingAssembly().GetName().Version.ToString();
            Console.Title = "To use No-Bling DOTA mod, add launch option: -tempcontent"; Console.SetWindowSize(83, 38);
            lock (ConsoleWriterLock)
            {
                foreach (string line in logo)
                {
                    foreach (string block in line.Split(':'))
                    {
                        Console.ForegroundColor = ConsoleColor.Cyan;
                        if (block.Contains('#'))
                        {
                            Console.ForegroundColor = ConsoleColor.Red;
                        }
                        else if (block.Contains('`'))
                        {
                            Console.ForegroundColor = ConsoleColor.DarkRed;
                        }
                        else if (block.Contains("Bling"))
                        {
                            Console.ForegroundColor = ConsoleColor.Black; Console.BackgroundColor = ConsoleColor.Cyan;
                            Console.Write(block); Console.ResetColor();
                            continue;
                        }
                        Console.Write(block);
                    }
                    Console.ResetColor(); Console.WriteLine("\u00A0");
                }

                string online_version = "", url = "http://raw.githubusercontent.com/No-Bling/DOTA/master/.version";
                try
                {
                    var wc = new WebClient(); wc.Headers.Add("user-agent","iPad"); online_version = wc.DownloadString(url).Trim();
                } catch {}

                if (online_version != "" && online_version != version)
                    Console.WriteLine("          local version = " + version + "       github version = " + online_version);
            }
        }

        public static void NoBlingDOTABuilder()
        {
            var sw = Stopwatch.StartNew();
            Start(); // FreeScriptSoNoBitching

            var STEAMPATH = SlashPath(Environment.GetEnvironmentVariable("STEAMPATH"));
            var libraryfolders = KV.LoadFromFile(STEAMPATH + "/steamapps/libraryfolders.vdf");
            if (libraryfolders == null)
            {
                Echo(" /steamapps/libraryfolders.vdf not found in STEAMPATH \n STEAMPATH = " + STEAMPATH, 1, ConsoleColor.Red);
                Console.ReadKey(); return;
            }
            var GAMEPATH = SlashPath(Environment.GetEnvironmentVariable("GAMEPATH"));
            if (!Directory.Exists(GAMEPATH + "/dota/maps"))
            {
                GAMEPATH = STEAMPATH + "/steamapps/common/dota 2 beta/game";
                if (!Directory.Exists(GAMEPATH))
                {
                    foreach (KV folder in libraryfolders)
                    {
                        GAMEPATH = SlashPath(folder.v) + "/steamapps/common/dota 2 beta/game";
                        if (Directory.Exists(GAMEPATH + "/dota/maps")) break;
                    }
                }
            }

            // Read vpk data
            string sourcefile = GAMEPATH + "/dota/pak01_dir.vpk", outputfile = GAMEPATH + "/dota_tempcontent/pak01_dir.vpk";
            Package source = new Package(), output = new Package(), existing = new Package();
            try { source.Read(sourcefile); } catch (Exception e) { Echo(e.ToString(), 1, ConsoleColor.Yellow); }
            var items_game = "scripts/items/items_game.txt";
            var chat_wheel = "scripts/chat_wheel.txt";
            var null_vpcf = "particles/dev/empty_particle.vpcf";
            var null_vmat = "materials/dev/bloom_cs.vmat";
            var null_vmdl = "models/development/invisiblebox.vmdl";
            var null_vsnd = "sounds/null.vsnd";
            var data = new Dictionary<string,byte[]>(); var crc = new Dictionary<string,uint>();
            foreach (var s in new[] {items_game, chat_wheel, null_vpcf, null_vmat, null_vmdl, null_vsnd})
            {
               var s_entry = source.FindEntry(s.EndsWith(".txt") ? s : s + "_c");
               if (s_entry == null)
                  throw new InvalidDataException("NO " + s + " in pak01_dir.vpk!");
               byte[] s_data; source.ReadEntry(s_entry, out s_data); data[s] = s_data; crc[s] = s_entry.CRC32;
            }
            data["null"] = new byte[0];
            var items = KV.LoadFromBytes(data[items_game]);
            if (items == null)
                throw new InvalidDataException("BAD scripts/items/items_game.txt in pak01_dir.vpk!");

            // PatchAnticipationStation: compare items_game.txt CRC from sourcefile with cached PAS from outputfile
            var PAS = true; //
            if (File.Exists(outputfile))
            {
                try { existing.Read(outputfile);
                    var pas_entry = existing.FindEntry(" ","PAS"," ");
                    if (pas_entry != null)
                    {
                        byte[] pas_data; existing.ReadEntry(pas_entry, out pas_data);
                        if (Encoding.UTF8.GetString(pas_data) == crc[items_game].ToString()) PAS = false;
                    }
                } catch { }
                existing.Dispose();
            }
            Echo(PAS ? "\n[new patch] " : "\n[old patch] ", 0, PAS ? ConsoleColor.Green : ConsoleColor.Magenta);

            // Quit early if there's no need to update the mod
            if (PAS == false && Options.Silent)
            {
                Echo("Mod is up-to-date", 1, ConsoleColor.Green);
                return;
            }

            // Show Choices Dialog
            var all = "Couriers,Wards,Heroes,Wearables,Abilities,GlanceValue,Taunts,SoundBoard,Loadout,Potato";
            var def = "Couriers,Wards,Wearables,Abilities,Taunts,Loadout";
            var old = KV.LoadFromFile("No-Bling-choices.txt");
            var sel = (old == null || old["sel"].v.Split(',').Except(all.Split(',')).Any()) ? def : old["sel"].v;
            var choices = sel.Split(',').ToList();

            if (Options.Silent == false)
            {
                sw.Stop();
                choices = Choices.Dialog(all, sel, def, "No-Bling DOTA mod", 14, "Ivory", "Maroon");
                sw.Start();
                if (choices.Count == 0) return;
                if (choices.Except(sel.Split(',')).Any() || sel.Split(',').Except(choices).Any())
                {
                    var s = new KV("No-Bling"); s.add("sel", choices); s.SaveToFile("No-Bling-choices.txt");
                }
            }
            Echo(String.Join(", ", choices));

            // Dev filters
            KV filters = Filters(choices);

            // Import user-defined filters
            KV user_filters = KV.LoadFromFile("No-Bling-filters.txt");
            if (user_filters != null)
            {
                Echo(user_filters, 1, ConsoleColor.DarkYellow);
                foreach (var pair in user_filters)
                {
                    if (pair.k == "keep_soundboard")       filters["keep_soundboard"].add(pair.vlist);
                    else if (pair.k == "keep_rarity")      filters["keep_rarity"].add(pair.vlist);
                    else if (pair.k == "keep_slot")        filters["keep_slot"].add(pair.vlist);
                    else if (pair.k == "keep_hero")        filters["keep_hero"].add(pair.vlist);
                    else if (pair.k == "keep_item")        filters["keep_item"].add(pair.vlist);
                    else if (pair.k == "keep_model")       filters["keep_model"].add(pair.vlist);
                    else if (pair.k == "keep_visuals")     filters["keep_visuals"].add(pair.vlist);
                    else if (pair.k == "keep_ability")     filters["keep_ability"].add(pair.vlist);
                    else if (pair.k == "keep_ambient")     filters["keep_ambient"].add(pair.vlist);
                    else if (pair.k == "keep_type")        filters["keep_type"].add(pair.vlist);
                    else if (pair.k == "keep_asset")       foreach (var entry in pair) { filters["keep_asset"].add(entry); }
                    else if (pair.k == "keep_modifier")    foreach (var entry in pair) { filters["keep_modifier"].add(entry); }
                    else if (pair.k == "replace_snapshot") foreach (var entry in pair) { filters["replace_snapshot"].add(entry); }
                    else if (pair.k == "replace_model")    foreach (var entry in pair) { filters["replace_model"].add(entry); }
                    else if (pair.k == "replace_visuals")  foreach (var entry in pair) { filters["replace_visuals"].add(entry); }
                    else if (pair.k == "replace_item")     foreach (var entry in pair) { filters["replace_item"].add(entry); }
                    else if (pair.kint != -1)
                    {
                        if (pair.count > 0)                filters["replace_item"].add(pair);
                        else if (pair.vint != -1)          filters["replace_item"].add(pair);
                        else if (pair.v == "*")            filters["keep_item"].add(pair.k);
                        else                               filters["keep_item"].add(pair.k).add(pair.vlist);
                    }
                    else if (pair.k.Contains("/"))         filters["replace_file"].add(pair);
                }
            }

            // Soundboard
            if (choices.Contains("SoundBoard") && filters["keep_soundboard"]["TI10_Ceeeb"].notfound)
                foreach (var s in "ceeeb_start ceeeb_stop".Split())
                    output.AddEntry("sounds/misc/soundboard", s, "vsnd_c", data[null_vsnd]);
            var soundboard_reference = new List<string>();
            var soundboard = KV.LoadFromBytes(data[chat_wheel]);
            if (soundboard != null)
            {
                foreach (var s1 in soundboard["messages"]) foreach (var s2 in s1)
                {
                    if (s2.k != "sound") continue;
                    soundboard_reference.Add(s1.k);
                    if (choices.Contains("SoundBoard") && filters["keep_soundboard"][s1.k].notfound)
                        s2.v = "Dota.UpdateVODefault";
                }
                foreach (var s1 in soundboard["hero_messages"]) foreach (var s2 in s1) foreach (var s3 in s2)
                {
                    if (s3.k != "sound") continue;
                    soundboard_reference.Add(s2.k);
                    if (choices.Contains("SoundBoard") && filters["keep_soundboard"][s2.k].notfound)
                        s3.v = "Dota.UpdateVODefault";
                }
                using (var ms = new MemoryStream())
                {
                    soundboard.SaveToStream(ms); output.AddEntry("scripts", "chat_wheel", "txt", ms.ToArray());
                }
            }

            // Items
            var mod = items["items"];
            var basic = new KV("vanilla");

            // items_game.txt loop to populate prefab categories
            var categories = "Wearables,Heroes,Couriers,Wards,Taunts,Loadout";
            var cat = new Dictionary<string,List<int>>();
            foreach (var entry in categories.Split(',')) { cat[entry] = new List<int>(); }
            for (int n = 0; n < mod.items.Count; n++)
            {
                var prefab = mod.items[n]["prefab"].v;
                if (prefab == "wearable")                                            cat["Wearables"].Add(n); // +bundle?
                else if (prefab == "default_item")                                   cat["Heroes"].Add(n);
                else if (prefab == "courier" || prefab == "courier_wearable")        cat["Couriers"].Add(n);
                else if (prefab == "ward")                                           cat["Wards"].Add(n);
                else if (prefab == "taunt")                                          cat["Taunts"].Add(n);
                else if (prefab == "misc" || prefab == "tool" || prefab == "emblem") cat["Loadout"].Add(n);
            }

            foreach (var c in cat["Loadout"])
            {
                if (choices.Contains("Loadout") == false)
                    break;
                var i = mod.items[c]; var name = i["prefab"].v + " " + i.k + ":" + i["name"].v;
                if (filters["keep_item"][i.k].found)
                    continue;
                foreach (var visual in i["visuals"])
                {
                    if (visual["type"].v == "particle" || visual["type"].v == "particle_create")
                        visual.k = "bling";
                }
                i["visuals"].remove("bling");
            }

            foreach (var n in cat["Taunts"])
            {
                if (choices.Contains("Taunts") == false)
                    break;
                var i = mod.items[n];
                if (filters["keep_item"][i.k].found || filters["keep_hero"][i["used_by_heroes"].first.k].found)
                    continue;
                i.remove("visuals"); i.remove("portraits");
            }

            foreach (var n in cat["Wards"])
            {
                if (choices.Contains("Wards") == false)
                    break;
                var i = mod.items[n];
                if (i["baseitem"].found || filters["keep_item"][i.k].found)
                    continue;
                foreach (var visual in i["visuals"])
                {
                    if (visual["type"].v == "particle" || visual["type"].v == "particle_create")
                        visual.k = "bling";
                }
                i["visuals"].remove("bling");
            }

            foreach (var n in cat["Couriers"])
            {
                if (choices.Contains("Couriers") == false)
                    break;
                var i = mod.items[n];
                if (i["baseitem"].found || filters["keep_item"][i.k].found)
                    continue;
                foreach (var visual in i["visuals"])
                {
                    if (visual["type"].v == "particle" || visual["type"].v == "particle_create")
                        visual.k = "bling";
                }
                i["visuals"].remove("bling");
            }

            foreach (var n in cat["Heroes"])
            {
                var i = mod.items[n]; string hero = i["used_by_heroes"].first.k, slot = i["item_slot"].v ?? "weapon";
                if (hero == null)
                    continue; // expired / bugged
                basic.add(hero).add(slot).add("id",i.k); basic[hero][slot].add("vanilla_ambient");
                if (i["particle_folder"].found) basic[hero][slot].add("particle_folder", i["particle_folder"].v ?? "");
                foreach (var visual in i["visuals"])
                {
                    if (visual["type"].v != "particle_create")
                        continue;
                    basic[hero].add(visual["modifier"].v);
                    if (slot == "weapon" || slot == "offhand_weapon" || slot == "ambient_effects")
                        basic[hero][slot]["vanilla_ambient"].add(visual["modifier"].v);
                  //Log("HEROES",visual["modifier"].v);
                }
            }

            // Wearables pass 1
            foreach (var n in cat["Wearables"])
            {
                var i = mod.items[n];
                string hero = i["used_by_heroes"].first.k, slot = i["item_slot"].v ?? "weapon";

                foreach (var ambiguous in i["visuals"])
                {
                    if (ambiguous["type"].v == "particle_create")
                    {
                        basic.add(hero).add(ambiguous["modifier"].v);
                    }
                }
            }

            // Wearables pass 2
            foreach (var n in cat["Wearables"])
            {
                var i = mod.items[n];
                string hero = i["used_by_heroes"].first.k, slot = i["item_slot"].v ?? "weapon", rarity = i["item_rarity"].v ?? "";

                if (hero == null || filters["keep_hero"][hero].found || filters["keep_item"][i.k].found ||
                  filters["keep_slot"][slot].found || filters["keep_rarity"][rarity].found) continue;

                var name = hero.Replace("npc_dota_hero_","") + " " + slot + " " + i.k + ":" + i["name"].v;
                var vanilla = basic[hero][slot]["id"].v ?? "";
                var vanilla_ambient = basic[hero][slot]["vanilla_ambient"].items;
                var vanilla_snapshot = filters["replace_snapshot"][hero][i.k].v;
                bool replace_ambient = (vanilla_ambient.Count > 0), replace_snapshot = (vanilla_snapshot != null);

                foreach (KV visual in i["visuals"])
                {
                    var type = visual["type"].v ?? "";
                    var asset = visual["asset"].v ?? "";
                    var modifier = visual["modifier"].v ?? "";

                    if (visual.k == "styles" || visual.k == "skip_model_combine" || filters["keep_type"][type].found)
                        continue;

                    if (type == "particle")
                    {
                        if (filters["keep_asset"][asset].found || filters["keep_asset"][hero].v == slot)
                        {
                            replace_ambient = false; continue;
                        }
                        else if (asset.EndsWith("loadout.vpcf"))
                        {
                            if (choices.Contains("Loadout") == false || filters["keep_loadout"][i.k].found)
                                continue;
                            Log("LOADOUT",asset);
                        }
                        else if (modifier == "particles/error/null.vpcf" || basic[hero][asset].found)
                        {
                            if (choices.Contains("Wearables") == false && choices.Contains("GlanceValue") == false)
                                continue;
                            if (filters["keep_ambient"][i.k].found)
                                continue;
                            Log("AMBIENT",asset);
                        }
                        else
                        {
                            if (choices.Contains("Abilities") == false || filters["keep_ability"][i.k].found)
                                continue;
                            Log("ABILITY",asset);
                        }
                    }
                    else if (type == "sound")
                    {
                        if (choices.Contains("Abilities") == false || filters["keep_ability"][i.k].found)
                            continue;
                        Log("ABILITY_SOUND",asset);
                    }
                    else if (type == "particle_create")
                    {
                      //if (modifier.StartsWith("particles/units/heroes")) { fix_ambient = false; continue; }
                        if (filters["keep_modifier"][modifier].found || filters["keep_modifier"][hero].v == slot)
                        {
                            replace_ambient = false; continue;
                        }
                        if (choices.Contains("Wearables") == false && choices.Contains("GlanceValue") == false)
                            continue;
                        if (filters["keep_ambient"][i.k].found)
                            continue;
                        Log("AMBIENT_CREATE",modifier);
                    }
                    else if (type == "particle_snapshot")
                    {
                        if (vanilla_snapshot != null && choices.Contains("Wearables") && filters["keep_ambient"][i.k].notfound)
                        {
                            visual["modifier"].v = vanilla_snapshot; replace_snapshot = false;
                            Log("replace_snapshot",vanilla_snapshot,"",name);
                        }
                        continue;
                    }
                    visual.k = "bling"; // mark for removal
                }
                i["visuals"].remove("bling");

                if (replace_ambient)
                {
                    i.add("visuals");
                    foreach (var ambient in vanilla_ambient)
                    {
                        var tmp = i["visuals"].add("tmp");
                        tmp.add("type", "particle_create"); tmp.add("modifier", ambient.k); tmp.k = "asset_modifier";
                        Log("vanilla_ambient",ambient.k,"",name);
                    }
                }

                if (replace_snapshot)
                {
                    var base_snapshot = filters["replace_snapshot"][hero][slot].v;
                    if (base_snapshot == null)
                        continue;
                    i.add("visuals"); i["visuals"].items.Insert(0, new KV("asset_modifier")); var tmp = i["visuals"].items[0];
                    tmp.add("type", "particle_snapshot"); tmp.add("asset", base_snapshot); tmp.add("modifier", vanilla_snapshot);
                    Log("vanilla_snapshot",vanilla_snapshot,"",name);
                }

                if (choices.Contains("Abilities") && filters["keep_ability"][i.k].notfound)
                {
                    var gems = i["static_attributes"].having("attribute_class", "socket");
                    foreach (var gem in gems) { i["static_attributes"].items.Remove(gem); }
                }

                if (choices.Contains("Heroes"))
                {
                    if (slot == "persona_selector")
                        i.remove("visuals");
                }

                if (choices.Contains("Loadout") && filters["keep_ability"][i.k].notfound)
                {
                    var portrait_particle = i["portraits"]["icon"]["PortraitParticle"].v;
                    if (portrait_particle != null) filters["replace_file"].add(portrait_particle, "-");
                }

                if (choices.Contains("GlanceValue") && filters["keep_model"][i.k].notfound)
                {
                    foreach (var model in "model_player model_player1 model_player2 model_player3".Split())
                    {
                        if (i[model].found) i[model].v = mod[vanilla][model].v ?? null_vmdl;
                    }
                    i.remove("portraits");
                    if (vanilla != "" && mod[vanilla]["portraits"].found)
                    i.add(mod[vanilla]["portraits"]);

                    if (filters["keep_visuals"][i.k].notfound)
                    {
                        i.remove("visuals");
                        if (vanilla != "" && mod[vanilla]["particle_folder"].found)
                            i.add(mod[vanilla]["particle_folder"]);
                      //if (vanilla != "" && mod[vanilla]["visuals"].found)
                          //i.add(mod[vanilla]["visuals"]);
                        var gems = i["static_attributes"].having("attribute_class", "socket");
                        foreach (var gem in gems) { i["static_attributes"].items.Remove(gem); }
                    }
                }

                var replace_model = filters["replace_model"][i.k].v ?? filters["replace_model"][hero][slot].v;
                if (replace_model != null && replace_model != i.k && filters["keep_model"][i.k].notfound)
                {
                    foreach (var model in "model_player model_player1 model_player2 model_player3".Split())
                    {
                        if (mod[replace_model][model].v == null)
                            continue;
                        i.add(model, mod[replace_model][model].v);
                        Log("replace_model", i.k, "=", replace_model);
                    }
                }

                var replace_visuals = filters["replace_visuals"][i.k].v ?? filters["replace_visuals"][hero][slot].v;
                if (replace_visuals != null && replace_visuals != i.k && filters["keep_visuals"][i.k].notfound)
                {
                    i.remove("visuals"); if (mod[replace_visuals]["visuals"].found) i.items.Add(mod[replace_visuals]["visuals"]);
                    Log("replace_visuals", i.k, "=", replace_visuals);
                }

                if (i["visuals"].count == 0) i.remove("visuals");
            }

            // replace_item id1 with id2 or {pasted content} while preserving selected properties
            var props = "name,prefab,item_description,item_name,item_rarity,item_type_name,item_slot,used_by_heroes";
            foreach (KV pair in filters["replace_item"])
            {
                KV preserved = new KV(), item1 = mod[pair.k], item2 = pair.count == 0 ? mod[pair.v] : pair;
                if (item2.count == 0)
                    continue;
                foreach (var prop in props.Split(',')) { if (item1[prop].k != null) preserved.items.Add(item1[prop]); }
              //item1.items.Clear();
                foreach (KV prop in item2) { item1.add(prop); }
                foreach (KV prop in preserved) { item1.add(prop); }
                Log("replace_item", pair.k, "=", (pair.v ?? "{..}"));
            }
            // Hint: add replaced ids to keep_item filter if you want to prevent pre-processing

            // Save items_game.txt
            using (var ms = new MemoryStream())
            {
                items.SaveToStream(ms);
                output.AddEntry("scripts/items", "items_game", "txt", ms.ToArray());
            }

            // Include resources from filters
            foreach (KV filter in filters["replace_file"])
            {
                var fdata = data["null"];
                if (filter.v.Contains("/"))
                {
                    var fentry = source.FindEntry(filter.v);
                    if (fentry != null) source.ReadEntry(fentry, out fdata);
                }
                else if (filter.k.EndsWith(".vpcf_c")) fdata = data[null_vpcf];
                else if (filter.k.EndsWith(".vmat_c")) fdata = data[null_vmat];
                else if (filter.k.EndsWith(".vmdl_c")) fdata = data[null_vmdl];
                else if (filter.k.EndsWith(".vsnd_c")) fdata = data[null_vsnd];
                output.AddEntry(filter.k, fdata);
                Log("replace_file",filter.k);
            }

            // Include any external resources from a "pak01_dir" folder along the script
            if (Directory.Exists("pak01_dir"))
            {
                output.AddFolder("pak01_dir");
            }

            // Update PatchAnticipationStation
            output.AddEntry(" ","PAS"," ", Encoding.UTF8.GetBytes(crc[items_game].ToString()));

            // Generate output pak01_dir.vpk
            output.SaveToFile(outputfile);

            // Generate items_reference.txt for user filters
            if (Options.Silent == false && !File.Exists("items_reference.txt"))
            {
                var reference = KV.LoadFromBytes(data[items_game])["items"];
                foreach (var i in reference)
                {
                    var p = i["prefab"].v;
                    if (p == "wearable" || p == "default_item" || p == "courier" || p == "courier_wearable" || p == "ward" ||
                      p == "taunt" || p == "misc" || p == "tool" || p == "emblem") i.remove("portraits");
                    else i.k = "";
                }
                reference.remove(""); reference.add("soundboard").add(soundboard_reference);
                reference.SaveToFile("items_reference.txt");
            }

            sw.Stop();
            Echo(String.Format("Done in {0}s\n", sw.Elapsed.TotalSeconds), 1, ConsoleColor.Cyan);
            HowTo(); // FreeScriptSoNoBitching
        }

        // Dev filters to set categories and preapply various corrections
        private static KV Filters(List<string> choices)
        {
            var dev = KV.LoadFromString(@"filters {
  replace_snapshot {
    npc_dota_hero_antimage {
      weapon  particles/models/heroes/antimage/antimage_weapon_primary.vsnap
      6325  particles/models/items/antimage/pw_tustarkuri_weapon/antimage_weapon_lod0.vsnap
      7277  particles/models/items/silencer/silencer_ti8_immortal_weapon/silencer_ti8_immortal_weapon_fx_handle.vsnap
      8271  particles/models/items/silencer/silencer_ti8_immortal_weapon/silencer_ti8_immortal_weapon_fx_handle.vsnap
      8734  particles/models/items/antimage/god_eater_weapon/god_eater_weapon_fx.vsnap
      9728  particles/models/items/antimage/avenging_anchorite_weapon/avenging_anchorite_weapon_fx.vsnap
      offhand_weapon  particles/models/heroes/antimage/antimage_weapon_offhand.vsnap
      6326  particles/models/items/antimage/pw_tustarkuri_weapon_offhand/antimage_weapon_offhand_lod0.vsnap
      7276  particles/models/items/silencer/silencer_ti8_immortal_weapon/silencer_ti8_immortal_weapon_fx_handle.vsnap
      8324  particles/models/items/silencer/silencer_ti8_immortal_weapon/silencer_ti8_immortal_weapon_fx_handle.vsnap
      8735  particles/models/items/antimage/god_eater_off_hand/god_eater_off_hand_fx.vsnap
      9727  particles/models/items/antimage/avenging_anchorite_off_hand/avenging_anchorite_off_hand_fx.vsnap
    }
    npc_dota_hero_ember_spirit {
      weapon  particles/models/heroes/ember_spirit/weapon1.vsnap
      7472  particles/models/items/ember_spirit/rapier_burning_god_weapon/rapier_burning_god_weapon.vsnap
      offhand_weapon  particles/models/heroes/ember_spirit/weapon2.vsnap
      7470  particles/models/items/ember_spirit/rapier_burning_god_weapon/rapier_burning_god_weapon.vsnap
    }
    npc_dota_hero_juggernaut {
      weapon  particles/models/heroes/juggernaut/juggernaut.vsnap
      4015  particles/models/items/juggernaut/bladesrunner_weapon/bladesrunner_weapon.vsnap
      4072  particles/models/items/juggernaut/juggernaut_horse_sword/juggernaut_horse_sword.vsnap
      4083  particles/models/items/juggernaut/juggernaut_horse_sword/juggernaut_horse_sword.vsnap
      4100  null.vsnap  4101  null.vsnap
      4102  particles/models/items/juggernaut/fire_of_the_exiled_ronin/fire_of_the_exiled_ronin.vsnap
      4250  particles/models/items/juggernaut/susano_os_descendant_weapon/susano_os_descendant_weapon_fx.vsnap
      4904  particles/models/items/juggernaut/fire_of_the_exiled_ronin/fire_of_the_exiled_ronin.vsnap
      4965  particles/models/items/juggernaut/gifts_of_the_vanished_weapon/gifts_of_the_vanished_weapon.vsnap
      5339  particles/models/items/juggernaut/wandering_demon_sword/wandering_demon_sword.vsnap
      5438  particles/models/items/juggernaut/fire_of_the_exiled_ronin/fire_of_the_exiled_ronin.vsnap
      5475  particles/models/items/juggernaut/the_discipline_of_kogu/the_discipline_of_kogu.vsnap
      5582  particles/models/items/juggernaut/the_elegant_stroke/the_elegant_stroke.vsnap
      6058  particles/models/items/juggernaut/wandering_demon_sword/wandering_demon_sword.vsnap
      6072  particles/models/items/juggernaut/juggernaut_horse_sword/juggernaut_horse_sword.vsnap
      6083  particles/models/items/ember_spirit/vanishing_flame_off_hand/vanishing_flame_off_hand_fx.vsnap
      6108  particles/models/items/juggernaut/gifts_of_the_vanished_weapon/gifts_of_the_vanished_weapon.vsnap
      6794  particles/models/items/juggernaut/jadeserpent_weapon/jadeserpent_weapon.vsnap
      6847  particles/models/items/juggernaut/bladesrunner_weapon/bladesrunner_weapon.vsnap
      7076  particles/models/items/juggernaut/juggernaut_horse_sword/juggernaut_horse_sword.vsnap
      7481  particles/models/items/ember_spirit/vanishing_flame_off_hand/vanishing_flame_off_hand_fx.vsnap
      8236  particles/models/items/juggernaut/fire_of_the_exiled_ronin/fire_of_the_exiled_ronin.vsnap
      8709  particles/models/items/juggernaut/bladesrunner_weapon/bladesrunner_weapon.vsnap
      8986  particles/models/items/juggernaut/wandering_demon_sword/wandering_demon_sword.vsnap
      9984 particles/models/items/juggernaut/wandering_demon_sword/wandering_demon_sword.vsnap
      12296 particles/models/items/juggernaut/wandering_demon_sword/wandering_demon_sword.vsnap
      12417 particles/models/items/juggernaut/immortal_warlord_sword/immortal_warlord_sword.vsnap
      12765 null.vsnap
      13185 particles/models/items/juggernaut/susano_os_descendant_weapon/susano_os_descendant_weapon_fx.vsnap
      13494 particles/models/items/juggernaut/the_discipline_of_kogu/the_discipline_of_kogu.vsnap
    }
  }
  replace_item {
    4864 {item_slot disabled}
  }
  replace_visuals {
    6972 5712  8773 5712  6919 6892  npc_dota_hero_furion { weapon 4159 }
  }
  replace_model{} replace_file{}
  keep_type {
    skip_model_combine - styles - alternate_icons - model - model_skin - entity_model - entity_scale - entity_healthbar_offset -
    hero_model_change - hero_scale - healthbar_offset - hex_model - additional_wearable - activity - default_idle_expression -
    response_criteria - tiny_voice - particle_control_point - arcana_level - pet - //buff_modifier custom_kill_effect
  }
  keep_asset {
    npc_dota_hero_bounty_hunter weapon
    npc_dota_hero_bounty_hunter offhand_weapon
    npc_dota_hero_phantom_assassin weapon
    npc_dota_hero_warlock ability_ultimate
    npc_dota_hero_skywrath_mage weapon
  }
  keep_modifier {
    npc_dota_hero_skywrath_mage weapon
    particles/units/heroes/hero_juggernaut/juggernaut_blade_generic.vpcf -
  }
  keep_item { 4159 - }
  keep_visuals { 4159 - }
  keep_ambient{} keep_ability{} keep_model{} keep_hero{} keep_slot{} keep_rarity{} keep_soundboard{}

            }");

            var loadout = KV.LoadFromString(@"replace_file {
    particles/ui/pregame_dire_ambient.vpcf_c -  particles/ui/static_fog_flash.vpcf_c -
    particles/ui/static_ground_smoke.vpcf_c -  particles/ui/static_ground_smoke_soft.vpcf_c -
    particles/ui/static_ground_smoke_soft_ring.vpcf_c -  particles/ui/static_ground_smoke_soft_small.vpcf_c -
    particles/ui/ui_game_start_hero_spawn.vpcf_c -  particles/ui/ui_game_start_hero_spotlight.vpcf_c -
    particles/ui/ui_loadout_preview.vpcf_c -  particles/ui/ui_mid_debris.vpcf_c -
    particles/ui/ui_treasure_opening.vpcf_c -
    particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_loadout_rare_model.vpcf_c -
    particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_loadout_rare_model.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/frosty_effigy_ambient_radiant.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/frosty_effigy_ambient_dire.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/jade_effigy_ambient_radiant.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/jade_effigy_ambient_dire.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_radiant.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_dire.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_radiant_lvl2.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_dire_lvl2.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_radiant.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_dire.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_radiant_lvl2.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_dire_lvl2.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_radiant_lvl3.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_dire_lvl3.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/se_ambient_ti6_lvl3.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/se_ambient_ti6_lvl3_base.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/se_ambient_fm16_rad_lvl1.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/se_ambient_fm16_dire_lvl1.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/se_ambient_fm16_rad_lvl2.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/se_ambient_fm16_dire_lvl2.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/se_ambient_fm16_rad_lvl3.vpcf_c -
    particles/econ/items/effigies/status_fx_effigies/se_ambient_fm16_dire_lvl3.vpcf_c -
            }");

            var potato = KV.LoadFromString(@"replace_file {
    maps/backgrounds/hero_frontpage_wraith_king_arcana.vpk -  maps/backgrounds/hero_frontpage_queen_of_pain.vpk -
    panorama/videos/ti10_aegis_frontpage.webm -  panorama/videos/ti10_aegis_frontpage_sm.webm -
    panorama/videos/ti10_background.webm -  panorama/videos/promo/international2020/ti10_terrain_vert.webm -
    panorama/videos/promo/international2020/wk_arc_upcomingrewards.webm -
            }");

            if (choices.Contains("Loadout")) dev["replace_file"].items.AddRange(loadout.items);
            if (choices.Contains("Potato")) dev["replace_file"].items.AddRange(potato.items);
            return dev;
        }
    }
}

/*
//  Script uses a rather block first, white-list later aproach, so various issues need to be corrected via hard-coded filters
//  Most filters use item numbers (ids) from scripts/items/items_game.txt but also generic hero and slot names
//  Advanced users can define extra exceptions in a "No-Bling-filters.txt" with the following vdf key-value format:

"user-filters"
{
  keep_soundboard "TI10_Ceeeb,Brutal"      // see scripts/chat_wheel.txt
  keep_rarity     "legendary,ancient"
  keep_slot       "head,voice"
  keep_hero       "npc_dota_hero_crystal_maiden,npc_dota_rattletrap_cog"
  keep_item       "12930,13456,12,38"
  keep_model      "4004,6054"
  keep_visuals    "4004"
  keep_ability    "7978"
  keep_ambient    "6694"

  // replace id1 with id2 content or { defined manually }
  38 7385
  12 {
    "model_player"    "models/items/kunkka/kunkka_shadow_blade/kunkka_shadow_blade.vmdl"
    "visuals"
    {
      "asset_modifier0"
      {
        "type"    "particle"
        "asset"   "particles/units/heroes/hero_kunkka/kunkka_weapon_glow_ambient.vpcf"
        "modifier"    "particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_glow_shadow_ambient.vpcf"
      }
      "asset_modifier3"
      {
        "type"    "particle_create"
        "modifier"    "particles/units/heroes/hero_kunkka/kunkka_weapon_glow_ambient.vpcf"
      }
    }
  }

  // Can also make use of the internal filters format:
  replace_item {
    246 { visuals{} }
    247 246
  }
  replace_visuals {
    6972 5712                              // explicit id1 "visuals" = id2 "visuals"
    npc_dota_hero_furion { weapon 4159 }   // generic hero - slot "visuals"  = id2 "visuals"
  }
  keep_asset {
    npc_dota_hero_warlock ability_ultimate // generic keep hero - slot having "type" "particle"
  }
  keep_modifier {
    npc_dota_hero_skywrath_mage weapon     // generic keep hero - slot having "type" "particle_create"
    particles/units/heroes/hero_juggernaut/juggernaut_blade_generic.vpcf -
  }
}

*/
